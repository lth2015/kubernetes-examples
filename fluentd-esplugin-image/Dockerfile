FROM tdagent-base:1.15

MAINTAINER dawei.li@company.com


# Copy the Fluentd configuration file.
COPY td-agent.conf /etc/td-agent/td-agent.conf

# Run the Fluentd service.
ENTRYPOINT ["td-agent"]
