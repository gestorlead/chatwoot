class DeleteEvolutionInstanceJob < ApplicationJob
  queue_as :low

  def perform(inbox)
    return unless inbox.channel.present?
    return unless inbox.name.present?

    # Obter a URL e a chave da API da Evolution
    evolution_api_url = ENV.fetch('EVOLUTION_API_URL', nil)
    evolution_api_key = ENV.fetch('EVOLUTION_API_KEY', nil)

    # Verificar se temos as informações necessárias
    return if evolution_api_url.blank? || evolution_api_key.blank? || inbox.name.blank?

    # Chama o método delete do ManagerService para excluir a instância
    Rails.logger.info("Deleting Evolution instance for inbox: #{inbox.name}")
    Evolution::ManagerService.new.delete(inbox.name, evolution_api_url, evolution_api_key)
  rescue StandardError => e
    Rails.logger.error "Error deleting Evolution instance: #{e.message}"
  end
end 