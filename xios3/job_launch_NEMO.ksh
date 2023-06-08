#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --ntasks-per-node=32
#SBATCH -J nemo_adastra
#SBATCH -e nemo_adastra.e%j
#SBATCH -o nemo_adastra.o%j
#SBATCH -A gda2307
#SBATCH --time=0:10:00
#SBATCH --constraint=GENOA

source /lus/home/NAT/gda2307/aalbert/.bashrc
load_cray

for file in $(ls /lus/work/CT1/ige2071/aalbert/WED025/WED025_demonstrator_forcings/); do
	cp /lus/work/CT1/ige2071/aalbert/WED025/WED025_demonstrator_forcings/$file .
done

#srun nemo #pas serveur
ln -sf /lus/work/NAT/gda2307/aalbert/DEV/bin-xios-3.0-beta-cray/bin/xios_server.exe xios
srun --multi-prog ./mpmd.conf # mode serveur
