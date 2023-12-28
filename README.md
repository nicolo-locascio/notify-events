## Descrizione

Componente Events per il progetto Notify (Piattaforma di notifica regionale). Si occupa di scodare gli eventi presenti nel message broker e di salvarli sul database. Gli eventi sono generati dai consumer che si occupano di inviare i messaggi sui vari canali. Espone API per la verifica dello stato di invio dei messaggi.

## Configurazione

Per una corretta configurazione della componente vedere il file **README.md** presente nella cartella *docs*.

## Installazione

* Clonare il repository in una cartella. (Il modulo dipende dalla componente [notify-commons](https://github.com/csipiemonte/notify-commons), pertanto nella cartella deve essere presente tale componente)
* Posizionarsi nella cartella del repository:  `cd notify-events`
* Eseguire il comando `npm install` per installare le dipendenze
* Eseguire lo script `./events` per avviare la componente
