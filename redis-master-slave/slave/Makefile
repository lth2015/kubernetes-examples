TAG=redis-slave:3.2.5

build:
	docker build -t img.reg.3g:15000/${TAG} .
push:
	docker push img.reg.3g:15000/${TAG}
test: 
	docker run -ti -e "MASTERIP=10.0.46.18" -e "MASTERPORT=6379" -e "MASTERAUTH=password" -e "PASSWORD=password" img.reg.3g:15000/${TAG} /bin/bash
clear:
	docker rmi -f img.reg.3g:15000/${TAG}
# deploy:
# 	kubectl create -f account-ws-dp.json
# 	kubectl create -f account-ws-svc.json
# undeploy:
# 	kubectl delete -f account-ws-dp.json
# 	kubectl delete -f account-ws-svc.json
