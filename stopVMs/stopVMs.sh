#! /bin/bash

# stopVMs - Script para organizar y automatizar el apagado de todas las VMs 
#     (Despues de confirmar que este funciona correctamente crear uno que ejecute 
#     este y tras hacer las comprobaciones necesarias apague el servidor)

# Tiempo (en minutos) m√ximo para esperar antes de forzar el apagado de un VM
maxWait=3

# Lista de VMs en funcionamiento (estado = running)
vmList=$(qm list | grep running | tr -s " " ":" | cut -d ':' -f2)

# Mandar se√al de apagado (ACPI shutdown) a todas las VMs en $vmList
for vm in $vmList; do
   qm shutdown $vm
done

# Bucle que comprueba si ya se han apagado todas las VMs, si no, espera.
while [ $maxWait -gt 0 ]; do
	vmList=$(qm list | grep running | tr -s " " ":" | cut -d ':' -f2)
	[ -z "$vmList" ] && echo "Todas las VMs se han apagado correctamente" | mail -s "[SysNotif] Apagado de VMs" correo@dominio.com && break
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
   echo $vmForced  | mail -s "[SysNotif] Apagado de las MVs" dominio@correo.com
fi


