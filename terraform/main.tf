resource "openstack_networking_floatingip_v2" "vm_fip" {
  count = var.vm_count
  pool = var.pool
}

resource "openstack_compute_instance_v2" "vm" {
  count = var.vm_count
  name = format("${var.instance_prefix}-%02d", count.index+1)
  image_name = var.image
  flavor_name = var.flavor
  key_pair = var.ssh_key_pair
  security_groups = [var.security_group]
  network {
    name = var.network_name
  }
}

resource "openstack_compute_floatingip_associate_v2" "vm_fip_assign" {
  count = var.vm_count
  instance_id = openstack_compute_instance_v2.vm.*.id[count.index]
  floating_ip = openstack_networking_floatingip_v2.vm_fip.*.address[count.index]
}

// workaround: we can't provision file and remote-exec before VMs have floating IP assigned
// so we create dummy step to execute script AFTER floating IPs are assigned
resource "null_resource" "vm_init" {
  count = var.vm_count
  depends_on = [
    openstack_compute_floatingip_associate_v2.vm_fip_assign
  ]

  connection {
    user = var.ssh_user_name
    private_key = file(var.ssh_key_path)
    host = openstack_networking_floatingip_v2.vm_fip.*.address[count.index]
  }

  provisioner "file" {
    source = var.vm_init_script
    destination = "/tmp/init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",
      "/tmp/init.sh"
    ]
  }
}

output "vm_ips" {
  value = openstack_compute_floatingip_associate_v2.vm_fip_assign.*.floating_ip
}