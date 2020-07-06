class Application < Roda
  plugin(:not_found) { { error: 'Not found' } }
  plugin(:json_parser)

  route do |r|
    r.root do
      '<h1>The RODA root</h1>'
    end
  end
end