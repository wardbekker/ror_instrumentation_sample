require 'prometheus_exporter/instrumentation'

#This collects activerecord connection pool metrics.
PrometheusExporter::Instrumentation::ActiveRecord.start(
  custom_labels: { type: "puma_single_mode" }, #optional params
  config_labels: [:database, :host] #optional params
)

PrometheusExporter::Instrumentation::Puma.start