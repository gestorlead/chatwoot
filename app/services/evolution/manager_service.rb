class Evolution::ManagerService
  def api_headers(api_key)
    { 'apikey' => api_key, 'Content-Type' => 'application/json' }
  end

  def create(account_id, name, webhook_url, api_key, access_token, ignore_groups = true, sign_messages = true, reopen_conversations = false)
    frontend_url = ENV.fetch('FRONTEND_URL', 'http://localhost:3000')
    internal_api_url = ENV.fetch('INTERNAL_API_URL', nil) || frontend_url
    response = HTTParty.post(
      "#{webhook_url}/instance/create",
      headers: api_headers(api_key),
      body: {
        instanceName: name,
        qrcode: true,
        integration: 'WHATSAPP-BAILEYS',
        groupsIgnore: ignore_groups,
        chatwootAccountId: account_id.to_s,
        chatwootToken: access_token,
        chatwootUrl: internal_api_url,
        chatwootSignMsg: sign_messages,
        chatwootReopenConversation: reopen_conversations,
        chatwootConversationPending: false,
        chatwootImportContacts: false,
        chatwootNameInbox: name,
        chatwootMergeBrazilContacts: true,
        chatwootImportMessages: false,
        chatwootDaysLimitImportMessages: 0,
        chatwootOrganization: 'WhatsApp Bot',
        chatwootLogo: "#{frontend_url}/assets/images/dashboard/channels/whatsapp.png"
      }.to_json
    )

    process_response(response)
  end

  def delete(name, webhook_url, api_key)
    # Primeiro faz o logout da instância
    logout_response = HTTParty.post(
      "#{webhook_url}/instance/logout",
      headers: api_headers(api_key),
      body: {
        instanceName: name
      }.to_json
    )

    Rails.logger.info("Logout response: #{logout_response}")

    # Após o logout, exclui a instância
    delete_response = HTTParty.delete(
      "#{webhook_url}/instance/delete",
      headers: api_headers(api_key),
      body: {
        instanceName: name
      }.to_json
    )

    process_response(delete_response)
  end

  def process_response(response)
    if response.success?
      Rails.logger.info("HTTP Request Successful: #{response}")
    else
      Rails.logger.error response.body
      nil
    end
  end
end
