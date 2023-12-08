locals {
  raw_content = jsondecode(file("${path.module}/zscalar.json"))

  root_node = local.raw_content["zscalerthree.net"]

  expected_output = flatten(
    [
      for continent, cities in local.root_node :
      [
        for city, details in cities : {
          display_name  = "${replace(continent, "continent : ", "")}/${replace(city, "city : ", "")}"
          address_space = [for detail in details : detail.range if detail.range != ""]
        }
      ]
    ]
  )

  expected_output_map = {
    for item in local.expected_output :
    item.display_name => item.address_space
  }
}

output "expected_output" {
  value = local.expected_output_map
}
