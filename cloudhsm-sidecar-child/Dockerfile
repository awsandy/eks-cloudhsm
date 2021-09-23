FROM cloudhsm-sidecar-base

# Copy startup scripts
COPY entrypoint.sh .
COPY startdaemon.sh .



# Set startup script permissions
RUN chmod +x entrypoint.sh && chmod +x startdaemon.sh

RUN chown -R cloudhsm:cloudhsm /cloudhsm && chmod -R 755 /cloudhsm

USER cloudhsm

# Run entrypoint script
ENTRYPOINT [ "./entrypoint.sh" ]

