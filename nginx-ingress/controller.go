/*
Copyright 2015 The Kubernetes Authors All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package main

import (
	"log"
	"os"
	"os/exec"
	"reflect"
	"strings"
	"text/template"

	"k8s.io/kubernetes/pkg/api"
	"k8s.io/kubernetes/pkg/apis/extensions"
	client "k8s.io/kubernetes/pkg/client/unversioned"
	"k8s.io/kubernetes/pkg/util"
)

type Context struct {
	Ingress *extensions.IngressList
	Secrets *api.SecretList
}

func shellOut(cmd string) {
	out, err := exec.Command("sh", "-c", cmd).CombinedOutput()
	if err != nil {
		log.Fatalf("Failed to execute %v: %v, err: %v", cmd, string(out), err)
	}
}

func hasPrefix(prefix, s string) bool {
	return strings.HasPrefix(s, prefix)
}

func hasSuffix(prefix, s string) bool {
	return strings.HasSuffix(s, prefix)
}

func main() {
	var ingClient client.IngressInterface
	var secretsClient client.SecretsInterface
	/* Anon http client
	config := client.Config{
		Host:     "http://localhost:8080",
		Username: "admin",
		Password: "admin",
	}
	kubeClient, err := client.New(&config)
	*/
	kubeClient, err := client.NewInCluster()	
	if err != nil {
		log.Fatalf("Failed to create client: %v.", err)
	} else {
		ingClient = kubeClient.Extensions().Ingress(api.NamespaceAll)
		secretsClient = kubeClient.Secrets(api.NamespaceAll)
	}
	tmpl := template.New("nginx.tmpl").Funcs(template.FuncMap{"hasprefix": hasPrefix, "hassuffix": hasSuffix})
	if _, err := tmpl.ParseFiles("./nginx.tmpl"); err != nil {
		log.Fatalf("Failed to parse template %v", err)
	}

	rateLimiter := util.NewTokenBucketRateLimiter(0.1, 1)
	known := &extensions.IngressList{}
	known_secrets := &api.SecretList{}

	// Controller loop
	shellOut("nginx")
	for {
		rateLimiter.Accept()
		ingresses, err := ingClient.List(api.ListOptions{})
		if err != nil {
			log.Printf("Error retrieving ingresses: %v", err)
			continue
		}
		secrets, err := secretsClient.List(api.ListOptions{})
		if err != nil {
			log.Printf("Error retrieving secrets: %v", err)
			continue
		}
		if reflect.DeepEqual(ingresses.Items, known.Items) && reflect.DeepEqual(secrets.Items, known_secrets.Items) {
			continue
		}
		// Process SSL context
		// old values
		known = ingresses
		known_secrets = secrets
		// context variable
		context := &Context{Ingress:ingresses, Secrets:secrets}
		if w, err := os.Create("/etc/nginx/nginx.conf"); err != nil {
			log.Fatalf("Failed to open %v: %v", err)
		} else if err := tmpl.Execute(w, context); err != nil {
			log.Fatalf("Failed to write template %v", err)
		}
		shellOut("nginx -s reload")
	}
}
