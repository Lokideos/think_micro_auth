class Application < Roda
  plugin(:not_found) { { error: 'Not found' } }
  plugin :environments
  plugin(:json_parser)

  route do |r|
    r.root do
      response['Content-Type'] = 'application/json'
      response.status = 200
      JSON({ status: "ok" })
    end
  end
end