Rails.application.config.middleware.use OmniAuth::Builder do
  provider :instagram, 'f17f3c48a3a1410c90edc76d5ee0ac09', '85027c4e5db84917a45375c54b0a4ef1', scope: 'basic public_content'
end