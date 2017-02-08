variable "latency_tags" {
  type = "list"
  default = [
    "app:circonus",
    "author:terraform",
    "resource:network",
  ]
}

resource "circonus_check" "icmp_ping" {
  collector {
    id = "${var.collectors_public[0]}"
  }

  name       = "ICMP Latency from Public (Ashburn, VA) Collector"
  notes      = <<EOF
This check measures the network latency between Vynjo's Enterprise Collector(s) and
www.vynjo.com.
EOF

  icmp_ping {
    count = 1
  }

  target = "www.vynjo.com"

  period = "60s"

  /*streams = ["circonus_metric.*.id"]*/
  /*circonus_metric*/
  stream {
    name = "${circonus_metric.icmp_minimum.name}"
    tags = ["${circonus_metric.icmp_minimum.tags}"]
    type = "${circonus_metric.icmp_minimum.type}"
    unit = "${circonus_metric.icmp_minimum.unit}"
    active = true
  }
  stream {
    name = "${circonus_metric.icmp_available.name}"
    tags = ["${circonus_metric.icmp_available.tags}"]
    type = "${circonus_metric.icmp_available.type}"
    unit = "${circonus_metric.icmp_available.unit}"
    active = true
  }
  stream {
    name = "${circonus_metric.icmp_average.name}"
    tags = ["${circonus_metric.icmp_average.tags}"]
    type = "${circonus_metric.icmp_average.type}"
    unit = "${circonus_metric.icmp_average.unit}"
    active = true
  }
  stream {
    name = "${circonus_metric.icmp_count.name}"
    tags = ["${circonus_metric.icmp_count.tags}"]
    type = "${circonus_metric.icmp_count.type}"
    unit = "${circonus_metric.icmp_count.unit}"
    active = false
  }
  stream {
    name = "${circonus_metric.icmp_maximum.name}"
    tags = ["${circonus_metric.icmp_maximum.tags}"]
    type = "${circonus_metric.icmp_maximum.type}"
    unit = "${circonus_metric.icmp_maximum.unit}"
    active = true
  }

  tags = [ "${var.latency_tags}" ]
}
/*
Uncomment this section if you want to have a check to/from your Enterprise Broker
resource "circonus_check" "icmp_latency" {
  collector {
    id = "${var.collectors_enterprise[0]}"
  }

  name       = "ICMP Latency from Enterprise Collector"
  notes      = <<EOF
This check measures the network latency between ENTERPRISE_BROKER_NAME Enterprise Collector(s) and
www.vynjo.com.
EOF

  icmp_ping {
    count = 1
  }

  target = "www.vynjo.com"

  period = "60s"

  stream {
    name = "${circonus_metric.icmp_latency.name}"
    tags = ["${circonus_metric.icmp_latency.tags}"]
    type = "${circonus_metric.icmp_latency.type}"
    unit = "${circonus_metric.icmp_latency.unit}"
  }

  tags = [ "${var.latency_tags}" ]
}*/

resource "circonus_metric" "icmp_minimum" {
  name = "minimum"
  type = "numeric"
  unit = "seconds"
  tags = [ "${var.latency_tags}" ]
}
resource "circonus_metric" "icmp_available" {
  name = "available"
  type = "numeric"
  tags = [ "${var.latency_tags}" ]
}
resource "circonus_metric" "icmp_average" {
  name = "average"
  type = "numeric"
  unit = "seconds"
  tags = [ "${var.latency_tags}" ]
}
resource "circonus_metric" "icmp_count" {
  name = "count"
  type = "numeric"
  tags = [ "${var.latency_tags}" ]
}
resource "circonus_metric" "icmp_maximum" {
  name = "maximum"
  type = "numeric"
  unit = "seconds"
  tags = [ "${var.latency_tags}" ]
}

resource "circonus_graph" "icmp_ping" {
  name = "Test 2 www.vynjo.com Ping Latency from Ashburn, VA Broker"
  description = "The minimum ping time between Vynjo's home broker and www.vynjo.com"
  line_style = "stepped"

  stream {
    check = "${circonus_check.icmp_ping.checks[0]}"
    stream_name = "minimum"
    metric_type = "numeric"
    axis = "left"
    color = "#17b6d6"
    name = "Ping Minimum Latency"
  }
  stream {
    check = "${circonus_check.icmp_ping.checks[0]}"
    stream_name = "maximum"
    metric_type = "numeric"
    axis = "left"
    color = "#17b6d6"
    name = "Ping Maximum Latency"
  }

  tags = [ "${var.latency_tags}" ]
}

resource "circonus_graph" "icmp_ping" {
  /* NOTE TO SELF - MAKE VARS AND INPUT PERAMETERS FOR THE MODULE!!!!! */
  name = "Test 1 www.vynjo.com Ping Roundtrip from Ashburn, VA Broker"
  description = "The round trip ping time between Vynjo's home broker and www.vynjo.com"
  line_style = "stepped"

  stream {
    check = "${circonus_check.icmp_ping.checks[0]}"
    stream_name = "average"
    metric_type = "numeric"
    axis = "left"
    color = "#17b6d6"
    name = "Ping Roundtrip Time"
  }

  tags = [ "${var.latency_tags}" ]
}
