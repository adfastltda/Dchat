bundle exec rails runner "
begin
  # 1. Configura o Plano
  plan = InstallationConfig.find_or_initialize_by(name: 'INSTALLATION_PRICING_PLAN')
  plan.value = 'enterprise'
  plan.locked = true
  plan.save!(validate: false)

  # 2. Configura a Quantidade de Usuários
  qty = InstallationConfig.find_or_initialize_by(name: 'INSTALLATION_PRICING_PLAN_QUANTITY')
  qty.value = 9_999_999
  qty.locked = true
  qty.save!(validate: false)

  # 3. Limpa alertas de limite no Redis
  if defined?(Redis::Alfred)
    Redis::Alfred.delete(Redis::Alfred::CHATWOOT_INSTALLATION_CONFIG_RESET_WARNING)
  end

  puts '✅ Enterprise ativado com sucesso no banco de dados!'
rescue => e
  puts '❌ Erro na ativação: ' + e.message
end
"
