NEO4J_CONFIG = YAML.load_file("#{::Rails.root}/config/neo4j.yml")[::Rails.env]
Neography.configure do |config|
  config.protocol       = "http://"
  config.server         = NEO4J_CONFIG['server']
  config.port           = NEO4J_CONFIG['port']
  config.directory      = ""  # prefix this path with '/' 
  config.cypher_path    = "/cypher"
  config.gremlin_path   = "/ext/GremlinPlugin/graphdb/execute_script"
  config.log_file       = "neography.log"
  config.log_enabled    = false
  config.max_threads    = 20
  config.authentication = nil  # 'basic' or 'digest'
  config.username       = nil
  config.password       = nil
  config.parser         = MultiJsonParser
end