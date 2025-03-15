# Documentação do Chatwoot-BR

Este documento descreve as modificações e extensões implementadas neste fork do Chatwoot original, com foco nas novas funcionalidades e alterações principais.

## 1. Integração com Evolution API

A Evolution API é uma das principais adições a este fork do Chatwoot original. Esta integração permite conectar o Chatwoot com instâncias do WhatsApp através de uma API externa, facilitando a gestão de comunicações via WhatsApp.

### Arquivos Criados para a Evolution API:

1. **Controller:**
   - `/app/controllers/api/v1/accounts/channels/evolution_channels_controller.rb`: Gerencia a criação e configuração de canais de comunicação com a Evolution API.

2. **Serviço:**
   - `/app/services/evolution/manager_service.rb`: Fornece métodos para gerenciar a conexão com a Evolution API, incluindo a criação de instâncias WhatsApp e processamento de respostas.

3. **Componente Frontend:**
   - `/app/javascript/dashboard/routes/dashboard/settings/inbox/channels/Evolution.vue`: Interface de usuário para configuração do canal Evolution API, permitindo aos usuários inserir o número de telefone para criar um canal WhatsApp.

4. **Cliente API:**
   - `/app/javascript/dashboard/api/channel/evolutionChannel.js`: Cliente API para comunicação com o backend da Evolution API.

### Configurações Adicionadas:

No arquivo `.env.example` e `.env.dev` foram adicionadas variáveis para configuração da Evolution API:
```
EVOLUTION_API_URL=http://0.0.0.0:8080
EVOLUTION_API_KEY=429683C4C977415CAAFCCE10F7D57E11
```

### Funcionalidades da Evolution API:

- **Criação de Canais WhatsApp**: Permite criar canais de comunicação WhatsApp através da Evolution API.
- **Integração com o Chatwoot**: Configura automaticamente a conexão entre o Chatwoot e a Evolution API, permitindo o fluxo de mensagens.
- **Autenticação via QR Code**: Suporta autenticação via QR code para conexão WhatsApp.
- **Configurações Personalizadas**: Várias opções de configuração para comportamento da integração, como importação de contatos, reabertura de conversas, etc.

## 2. Transcrição de Áudio

A segunda funcionalidade principal adicionada é a transcrição automática de áudios, que utiliza a API da OpenAI (via modelo Whisper) para converter mensagens de áudio em texto.

### Arquivos Criados para Transcrição de Áudio:

1. **Serviço de Transcrição:**
   - `/app/services/openai/audio_transcription_service.rb`: Implementa a integração com a API OpenAI para transcrição de áudio utilizando o modelo Whisper.

### Modificações para Suportar Transcrição:

1. **Controller de Mensagens:**
   - `/app/controllers/api/v1/accounts/conversations/messages_controller.rb`: Modificado para detectar anexos de áudio, processá-los através do serviço de transcrição e adicionar o texto transcrito à mensagem.

### Funcionamento da Transcrição:

1. Quando uma mensagem com anexo de áudio é enviada, o sistema detecta automaticamente o tipo de anexo.
2. Para cada anexo de áudio, um URL temporário é gerado.
3. O serviço de transcrição baixa o arquivo de áudio e o envia para a API da OpenAI.
4. A transcrição resultante é anexada ao conteúdo da mensagem original.
5. A mensagem é exibida com tanto o áudio original quanto a transcrição, facilitando a leitura e busca das informações.

### Configuração necessária:
Requer uma chave API da OpenAI que deve ser configurada na variável de ambiente `OPENAI_API_KEY`.

## 3. Traduções e Localizações

O fork também inclui traduções específicas para Português do Brasil (pt_BR), particularmente para:

- Elementos de interface relacionados à Evolution API
- Textos relacionados à transcrição de conversas

## 4. Diagrama de Funcionamento

### Evolution API:
1. Usuário configura canal WhatsApp via Evolution API no Chatwoot
2. Chatwoot cria uma instância na Evolution API
3. Evolution API gerencia a conexão com WhatsApp
4. Mensagens são sincronizadas entre WhatsApp e Chatwoot

### Transcrição de Áudio:
1. Mensagem com áudio é recebida no Chatwoot
2. Arquivo de áudio é extraído e URL temporário é gerado
3. Serviço de transcrição envia áudio para API da OpenAI
4. Texto transcrito é recebido e adicionado à mensagem original
5. Mensagem com áudio e transcrição é exibida ao usuário

## 5. Alterações e Adições Principais

Em resumo, as principais alterações neste fork do Chatwoot são:

1. **Adição da Integração com Evolution API**:
   - Permite integração com WhatsApp via API externa
   - Simplifica a configuração de canais WhatsApp

2. **Transcrição Automática de Áudio**:
   - Converte mensagens de áudio em texto usando IA
   - Melhora acessibilidade e busca nas conversas

3. **Localização para Português do Brasil**:
   - Tradução específica dos novos recursos
   - Melhor experiência para usuários brasileiros

Estas modificações tornam o sistema mais adequado para uso no Brasil, com melhor integração com WhatsApp (muito popular no país) e capacidade de lidar com mensagens de áudio (também muito utilizadas pelos brasileiros). 