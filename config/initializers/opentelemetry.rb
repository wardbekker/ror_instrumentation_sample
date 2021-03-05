require 'opentelemetry/sdk'
require 'opentelemetry/exporter/jaeger'

# Simple setup for demonstration purposes, simple span processor should not be
# used in a production environment
span_processor = OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(
   OpenTelemetry::Exporter::Jaeger::AgentExporter.new(host: 'agent', port: 6831)
)

# Configure the sdk with default export and context propagation formats
# see SDK#configure for customizing the setup
OpenTelemetry::SDK.configure do |c|
    c.use_all
  #c.use 'OpenTelemetry::Instrumentation::Rails'
 # c.use 'OpenTelemetry::Instrumentation::Rails'
 # c.use 'OpenTelemetry::Instrumentation::Rack'
#  c.use 'OpenTelemetry::Instrumentation::ActiveModelSerializers'
#  c.use 'OpenTelemetry::Instrumentation::Net::HTTP'
#  c.use 'OpenTelemetry::Instrumentation::Sidekiq'

   
  c.add_span_processor(span_processor)
  c.service_name = "RoR sample app"
 # c.version = "1.0"
end
