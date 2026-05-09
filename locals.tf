locals {
  common_tags = merge(
    { Name = var.name },
    var.tags
  )
}
