output "app_external_ip" {
  value = "${module.app.external_ip}"
}

output "db_external_ip" {
  value = "${module.db.external_ip}"
}

output "sandbox_external_ip" {
  value = "${module.sandbox.external_ip}"
}
