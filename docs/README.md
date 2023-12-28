# Introduzione

*events* è la componente che si occupa dello scodamento degli eventi scritti nelle code del message broker e del salvataggio sul database. Espone API per la verifica dello stato di invio dei messaggi.

## Getting Started

Per rendere operativo il sistema occorre:
1. creare lo schema sul database con lo script `dbscript/unpevents.sql`.
1. impostare gli opportuni valori delle variabili d'ambiente
1. editare il file di configurazione
1. avviare l'applicazione
    
### Prerequisites

* Istanza attiva di Postgres
* Componente Message broker attiva per leggere i messaggi

### Configuration

La configurazione è basata su variabili d'ambiente e file di configurazione. Una variabile può essere presente sia su variabile d'ambiente sia nel file di conf specifico dell'ambiente che nel file di conf generico della componente. All'avvio della comopnente viene effettuato il merge di questi tre entry point. Le variabili se prensenti in più punti (file o env) vengono gestite con la seguente priorità (dalla più alta alla più bassa):
* variabile d'ambiente
* file di conf specifico dell'ambiente
* file di conf generico della componente

Le variabili d'ambiente da valorizzare sono:
* `ENVIRONMENT`: rappresenta l'ambiente di esecuzione (ad esempio dev, tst o prod). Serve per individuare il file di configurazione secondario.

I file di configurazione sono `conf/events.json` e `conf/events-{ENVIRONMENT}.json`. Ove lo stesso parametro sia presente su entrambi i file il valore in `conf/events-{ENVIRONMENT}.json` ha la precedenza.

I principali attributi presenti nei file di configurazione sono elencati di seguito (per l'elenco completo visualizzare il contenuto dei file presenti nella cartella src/conf):

* `app_name`: nome dell'applicazione (obbligatorio per tracciatura degli eventi e check sicurezza)
* `server_port`: la porta in ascolto del server
* `db`: contiene la configurazione per la connessione al database. 
    * `host`: l'hostname del dbms
    * `database`: il nome del database a cui accedere
    * `user`: utente con cui accedere al db
    * `password`: password dell'utente del db
    * `schema`: database schema
* `mb`: contiene la configurazione per il Message Broker.
    * `queues`: contiene le informazioni per le code del message broker
        * `messages`: url della coda su cui leggere i messaggi da inviare
    * `token`: il token auth per chiamare il message broker
* `log4js`: la configurazione di log4js (vedi https://www.npmjs.com/package/log4js)

## Running

Avviare events
```
node src/events.js
node src/jobs/events.js
```

or

```
npm start
```
