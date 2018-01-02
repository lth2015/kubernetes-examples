package main

import (
	log "github.com/Sirupsen/logrus"
	"os"
	"time"
)

func init() {
	// Log as JSON instead of the default ASCII formatter.
	log.SetFormatter(&log.JSONFormatter{})

	// Output to stderr instead of stdout, could also be a file.
	log.SetOutput(os.Stderr)

	// Only log the warning severity or above.
	log.SetLevel(log.InfoLevel)
}

func main() {

	timer := time.NewTimer(time.Second * 2)

	for {
		<-timer.C

		log.WithFields(log.Fields{
			"animal": "walrus",
			"size":   10,
		}).Info("A group of walrus emerges from the ocean")

		log.WithFields(log.Fields{
			"omg":    true,
			"number": 122,
		}).Warn("The group's number increased tremendously!")

		log.WithFields(log.Fields{
			"omg":    true,
			"number": 100,
		}).Info("The ice breaks!")

		timer.Reset(2 * time.Second)

	}
}
