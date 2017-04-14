#! /bin/bash

# stopVMs - Script para  automatizar el apagado de todas las VMs

MAIL=dominio@correo.com
# Tiempo (en minutos) máximo para esperar antes de forzar el apagado de un VM
maxWait=3

# Lista de VMs en funcionamiento (estado = running)
vmList=$(qm list | grep running | tr -s " " ":" | cut -d ':' -f2)

# Mandar señal de apagado (ACPI shutdown) a todas las VMs en $vmList
for vm in $vmList; do
   qm shutdown $vm
done

# Bucle que comprueba si ya se han apagado todas las VMs, si no, espera.
while [ $maxWait -gt 0 ]; do
	vmList=$(qm list | grep running | tr -s " " ":" | cut -d ':' -f2)
	[ -z "$vmList" ] && echo "Todas las VMs se han apagado correctamente" | mail -s "[SysNotif] Apagado de VMs" $MAIL && break
	maxWait=$((maxWait-1))
	sleep 60
done

# Si pasa el tiempo determinado en $maxWait y no se ha terminado el apagado controlado
#  se fuerza el apagado
vmForced="Se ha tenido que forzar el apagado de las siguientes VMs: "
if [ $maxWait -eq 0 ]; then
   vmList=$(qm list | grep running | tr -s " " ":" | cut -d ':' -f2)
   for vm in $vmList; do
      qm stop $vm
      vmForced=$vmForced+$vm+", "
   done
   echo $vmForced  | mail -s "[SysNotif] Apagado de las MVs" $MAIL
fi
