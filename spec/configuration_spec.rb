require './lib/configuration.rb' 
describe "Configuration" do
  describe Configuration::SetUp do
    before(:each) do
      @setup= Configuration::SetUp.new
    end
    it "creates an array of performance pipeline names" do
      ENV['NO_OF_PIPELINES'] = '3'
      expect(@setup.pipelines).to eq(['perf1', 'perf2', 'perf3'])
    end
    it "defaults to 10 pipelines when the environment variable is not set" do
      ENV['NO_OF_PIPELINES'] = nil
      expect(@setup.pipelines).to eq(['perf1', 'perf2', 'perf3', 'perf4', 'perf5', 'perf6', 'perf7', 'perf8', 'perf9', 'perf10'])
    end
    it "create an array of agents names" do
      ENV['NO_OF_AGENTS'] = '2'
      expect(@setup.agents).to eq(['agent-1', 'agent-2'])
    end
    it "defaults to 10 agents" do
      ENV['NO_OF_AGENTS'] = nil
      expect(@setup.agents).to eq(['agent-1', 'agent-2', 'agent-3', 'agent-4', 'agent-5', 'agent-6', 'agent-7', 'agent-8', 'agent-9', 'agent-10'])
    end
    it "sets the default git repository host" do
      expect(@setup.git_repository_host).to eq('http://localhost')
    end
    it 'return the go full and short version' do
      ENV['GO_VERSION'] = "16.7.0-3883"
      expect(@setup.go_version).to eq(['16.7.0', '3883'])
    end
    it 'raises error of version number is missing' do
      ENV['GO_VERSION'] = nil
      expect{ @setup.go_version }.to raise_error { "Missing GO_VERSION environment variable" }
    end
    it 'raises error if the GO_VERSION is not in the right format' do
      ENV['GO_VERSION'] = '16.0'
      expect { @setup.go_version }.to raise_error (%{"GO_VERSION format not right, 
      we need the version and build e.g. 16.0.0-1234"})
    end
    it 'gets the config save interval and number of config saves' do
      ENV['CONFIG_SAVE_INTERVAL'] = '10'
      ENV['NUMBER_OF_CONFIG_SAVES'] = '20'
      expect(@setup.config_save_duration).to eq({ interval:10, times:20 })
    end
    it 'sets the default config save interval and number of config saves' do
      ENV['CONFIG_SAVE_INTERVAL'] = nil
      ENV['NUMBER_OF_CONFIG_SAVES'] = nil
      expect(@setup.config_save_duration).to eq({ interval: 5, times: 30 })
    end
    it 'sets the GIT_ROOT' do
      ENV['GIT_ROOT'] = 'gitroot'
      expect(@setup.git_root).to eq('gitroot')
    end
    it 'sets the /tmp folder as the default GIT_ROOT' do
      ENV['GIT_ROOT'] = nil
      expect(@setup.git_root).to eq('gitrepos')
    end
    it 'generates git repo names based on the number of pipelines' do
      ENV['NO_OF_PIPELINES'] ='3' 
      expect(@setup.git_repos).to eq(['git-repo-1', 'git-repo-2', 'git-repo-3'])
    end
  end

  describe Configuration::Server do
    before(:each) do
      @server = Configuration::Server.new
    end
    it "sets the server base url from SERVER env variable with default port" do
      ENV['GOCD_HOST'] = 'goserver'
      ENV['GO_SERVER_PORT'] = nil
      expect(@server.base_url).to eq('http://goserver:8153')
    end
    it "sets the server base url from SERVER and PORT environment variables" do
      ENV['GOCD_HOST'] = 'goserver' 
      ENV['GO_SERVER_PORT'] = '8253'
      expect(@server.base_url).to eq('http://goserver:8253')
    end
    it "sets the server base url using default SERVER and specified PORT" do
      ENV['GOCD_HOST'] = nil
      ENV['GO_SERVER_PORT'] = '8253'
      expect(@server.base_url).to eq('http://localhost:8253')
    end
    it "sets authentication in the server base url " do
      ENV['AUTH'] = 'admin:badger'
      ENV['GO_SERVER_PORT'] = '8253'
      ENV['GOCD_HOST'] = 'authenticated_url'
      expect(@server.base_url).to eq('http://admin:badger@authenticated_url:8253')
    end
    it 'sets the secure port' do
      ENV['GO_SERVER_SSL_PORT'] = '8254' 
      expect(@server.secure_port).to eq('8254')
    end
    it 'sets the default secure port' do
      ENV['GO_SERVER_SSL_PORT'] = nil
      expect(@server.secure_port).to eq('8154')
    end
    it "sets the url" do
     ENV['AUTH'] = nil
     ENV['GO_SERVER_PORT'] = '8153' 
     ENV['GOCD_HOST'] = "host"
     expect(@server.url).to eq('http://host:8153/go')
    end
    it 'gets the starup enviroment settings' do
      ENV['GO_SERVER_SYSTEM_PROPERTIES'] = 'properties'
      ENV['GO_SERVER_PORT']= 'port'
      ENV['GO_SERVER_SSL_PORT']= 'secureport'
      ENV['SERVER_MEM']= 'memory'
      ENV['SERVER_MAX_MEM']= 'max_memory'
      expect(@server.environment).to eq({ 
        "GO_SERVER_SYSTEM_PROPERTIES" => 'properties',
        "GO_SERVER_PORT" => 'port',
        "GO_SERVER_SSL_PORT" => 'secureport',
        "SERVER_MEM" => 'memory',
        "SERVER_MAX_MEM" => 'max_memory'
      }) 
    end
  end
end