FROM lscr.io/linuxserver/webtop:ubuntu-xfce
 
#RUN apk add --no-cache wine bash curl winetricks
#RUN apk add --no-cache terminus-font ttf-inconsolata ttf-dejavu font-noto ttf-font-awesome font-noto-extra \
#            font-vollkorn font-misc-cyrillic font-mutt-misc font-screen-cyrillic font-winitzki-cyrillic font-cronyx-cyrillic \
#            font-noto-thai font-noto-tibetan font-sony-misc font-daewoo-misc font-jis-misc \ 
#            font-noto-extra font-arabic-misc font-misc-cyrillic font-mutt-misc font-screen-cyrillic font-winitzki-cyrillic font-cronyx-cyrillic \
#            font-noto-arabic font-noto-armenian font-noto-cherokee font-noto-devanagari font-noto-ethiopic font-noto-georgian \
#            font-noto-hebrew font-noto-lao font-noto-malayalam font-noto-tamil font-noto-thaana font-noto-thai

RUN dpkg --add-architecture i386
RUN apt update
RUN apt full-upgrade -y
RUN apt install -y wine32 wine winetricks wget

ENV TZ=${TZ}
# Configure the virtual display port
ENV DISPLAY :0
# Set 32-bit env
ENV WINEARCH win32
# Disable wine debug messages
ENV WINEDEBUG -all
# Configure wine to run without mono or gecko as they are not required
ENV WINEDLLOVERRIDES mscoree,mshtml=
# Set the wine computer name
ENV COMPUTER_NAME bz-docker
# Configure the wine prefix location
#RUN mkdir /wine
ENV WINEPREFIX /config/wine
#ENV WINEPATH /usr/lib/wine/i386-windows/
# Create the data Directory
RUN mkdir /data

# Copy the start script to the container
COPY start.sh /start.sh

RUN chmod ugo+x /start.sh

#RUN echo "/start.sh" >> /defaults/startwm.sh
#RUN ["mkdir", "-p", "/defaults/.config/openbox/"]
#RUN echo "#!/bin/bash" > /defaults/startwm.sh
#RUN echo "/startpulse.sh &" >> /defaults/startwm.sh
#RUN echo "/usr/bin/startxfce4 > /dev/null 2>&1;" >> /defaults/startwm.sh

COPY backblaze.desktop /defaults/backblaze.desktop
COPY backblaze.desktop /etc/xdg/autostart/.
RUN echo "[[ ! -f /config/.config/autostart/backblaze.desktop ]] && cp /defaults/backblaze.desktop /config/.config/autostart/." >> /etc/cont-init.d/30-config

#RUN echo 'sh -c "sleep 10 && xterm -e /start.sh"' > /defaults/backblaze
#RUN echo "" >> /etc/cont-init.d/30-config
#RUN echo "[[ ! -d /config/.config/autostart ]] && mkdir -p /config/.config/autostart" >> /etc/cont-init.d/30-config
#RUN echo "[[ ! -f /config/.config/autostart/backblaze.desktop ]] && cp /defaults/backblaze.desktop /config/.config/autostart/." >> /etc/cont-init.d/30-config
#RUN ["cat", "/defaults/startwm.sh"]

RUN echo 'sleep 5 && xterm -e "/start.sh"' > /defaults/xinitrc
RUN echo "" >> /etc/cont-init.d/30-config
RUN echo "[[ ! -f /config/.xinitrc ]] && cp /defaults/xinitrc /config/.xinitrc" >> /etc/cont-init.d/30-config


#RUN echo "" >> /etc/xdg/xfce4/xinitrc
#RUN echo 'xterm -e "sleep 5 && xterm -e /start.sh"' >> /etc/xdg/xfce4/xinitrc

# Set the start script as entrypoint
#ENTRYPOINT ./start.sh
#CMD ["/bin/bash", "-c", "/start.sh"]
