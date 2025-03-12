#!/bin/bash
sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/disk/by-id/google-${var.disk_name}
sudo mkdir -p /mnt/disks/${var.disk_name}
sudo mount -o discard,defaults /dev/disk/by-id/google-${var.disk_name} /mnt/disks/${var.disk_name}
sudo chmod a+w /mnt/disks/${var.disk_name}\necho /dev/disk/by-id/google-${var.disk_name} /mnt/disks/${var.disk_name} ext4 defaults,discard 0 0 | sudo tee -a /etc/fstab