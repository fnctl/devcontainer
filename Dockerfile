FROM alpine:edge
ARG  USERNAME=developer
ARG  USER_ID=1000
RUN apk add -u --no-cache yq ca-certificates bash && rm -rf /var/cache/apk

COPY ./packages.yml /var/cache/
RUN yq eval '.install[]' /var/cache/packages.yml | xargs apk add -u --no-cache && rm -rf /var/cache/apk

# Ensure these folders and files exist before moving on
RUN mkdir -p \
      /var/lib/shared/overlay-images \
      /var/lib/shared/overlay-layers \
      /var/lib/shared/vfs-images \
      /var/lib/shared/vfs-layers \
&&  touch \
      /etc/containers/nodocker \
      /var/lib/shared/overlay-images/images.lock \
      /var/lib/shared/overlay-layers/layers.lock \
      /var/lib/shared/vfs-images/images.lock \
      /var/lib/shared/vfs-layers/layers.lock 

# Copy [the contents of] the ./etc/skel/ directory over [the contents of] the /etc/skel/
# directory in the container.
COPY ./etc/skel/ /etc/skel/

# Create the new group/user, add them to the sudoers file, add subuid/subgid for
# podman and then ensure permissions are correct where necessary.
RUN groupadd --gid $USER_ID $USERNAME \
&&  useradd -s /bin/zsh -K MAIL_DIR=/dev/null --uid $USER_ID --gid $USER_ID -m $USERNAME \
&&  echo $USERNAME ALL=\(root\) NOPASSWD:ALL >/etc/sudoers.d/$USERNAME \
&&  chmod 0440 /etc/sudoers.d/$USERNAME && chmod 644 /etc/containers/*.conf \
&&  sed -i \
      -e 's|^#mount_program|mount_program|g' \
      -e '/additionalimage.*/a "/var/lib/shared",' \
      -e 's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' \
      /etc/containers/storage.conf \
&&  echo -e "${USERNAME}:1:999\n${USERNAME}:1001:64535" | tee /etc/subuid /etc/subgid >/dev/null \ 
&&  mkdir -p /home/$USERNAME/.local/share/containers /home/$USERNAME/.config/containers \
&&  rsync -avz /etc/skel/ /root/ && chown -R 0:0 /root /root/.config \
&&  chown -R $USER_ID:$USER_ID /home/$USERNAME /home/$USERNAME/.local /home/$USERNAME/.config

COPY ./etc/bat.conf ./etc/starship.toml /etc/
ENV STARSHIP_CONFIG=/etc/starship.toml
ENV BAT_CONFIG_PATH=/etc/bat.conf

COPY ./etc/zsh/ /etc/zsh/
ENV SHELL=/bin/zsh
ENTRYPOINT ["/bin/zsh"]

ENV HOSTNAME=devcontainer
VOLUME /var/lib/containers
VOLUME /home/$USERNAME/.local/share/containers

# Set the user; their home directory; etc.
USER $USERNAME
ENV HOME=/home/$USERNAME
WORKDIR $HOME