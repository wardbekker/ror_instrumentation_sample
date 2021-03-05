ActiveSupport::Notifications.subscribe(/.*/) do |*args|
    event = ActiveSupport::Notifications::Event.new *args

    tracer = OpenTelemetry.tracer_provider.tracer

    name = event.name
    name = event.payload[:name] if name.nil?
    name = "unknown" if name.nil?
    span_kind = event.name == "sql.active_record" ? :server : :client
    span = tracer.start_span(name, start_timestamp: event.time, kind: span_kind)
    
    #span.start_timestamp = event.start
    event.payload.each do |k, v|
        span.set_attribute "#{k}", v.to_s
    end
    
    span.finish(end_timestamp: event.end) 
    
    attrs = Hash[event.payload.map{|k,v| ["#{k}", v.to_s] }]

    Rails.application.config.lograge.logger.info({cpu_time: event.cpu_time, duration: event.duration, event: event.name, payload_name: event.payload[:name] || "none", trace_id: span.context.trace_id.unpack1('H*')}.merge(attrs).to_json)
end