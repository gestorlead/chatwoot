module EvolutionDeletable
  extend ActiveSupport::Concern

  included do
    before_destroy :schedule_evolution_instance_deletion, if: :evolution_integration?
  end

  def evolution_integration?
    return false unless api?
    return false unless channel.present?
    return false unless channel.webhook_url.present?
    
    # Verifica se o webhook_url corresponde ao webhook da Evolution
    evolution_api_url = ENV.fetch('EVOLUTION_API_URL', nil)
    return false if evolution_api_url.blank?
    
    channel.webhook_url.include?(evolution_api_url) || channel.webhook_url.include?('/chatwoot/webhook/')
  end

  private

  def schedule_evolution_instance_deletion
    DeleteEvolutionInstanceJob.perform_later(self)
  end
end 