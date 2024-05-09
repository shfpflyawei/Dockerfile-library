FROM nginx:1.26.0
ENV NGINX_VERSION=1.26.0 MOD_SECURITY_VERSION=3.0.7 MOD_SECURITY_NGINX_VERSION=1.0.3 OWASP_CRS_VERSION=3.2.0
RUN set -xe; echo "Install required packages"; apt update; apt install -y libcurl4 liblmdb0 libxml2; apt install -y apt-utils autoconf automake build-essential git libcurl4-openssl-dev libgeoip-dev liblmdb-dev libpcre++-dev libtool libxml2-dev libyajl-dev pkgconf wget zlib1g-dev; echo "Install libmodsecurity"; cd /usr/local/src; git clone --depth 1 --branch "v${MOD_SECURITY_VERSION}" --single-branch https://github.com/SpiderLabs/ModSecurity.git ModSecurity; cd ModSecurity; git submodule init; git submodule update; ./build.sh; ./configure; make; make install; cd /usr/local/src; rm -rf ModSecurity; echo "Install modsecurity-nginx"; cd /usr/local/src; git clone --depth 1 --branch "v${MOD_SECURITY_NGINX_VERSION}" --single-branch https://github.com/SpiderLabs/ModSecurity-nginx.git ModSecurity-nginx; wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz; tar zxvf nginx-${NGINX_VERSION}.tar.gz; cd nginx-${NGINX_VERSION}; ./configure --with-compat --add-dynamic-module=../ModSecurity-nginx; make modules; cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules; cd /usr/local/src; rm -rf ModSecurity-nginx nginx-${NGINX_VERSION}.tar.gz nginx-${NGINX_VERSION}; echo "Enable ModSecurity"; sed -i '1iload_module modules/ngx_http_modsecurity_module.so;' /etc/nginx/nginx.conf; sed -i '/server {/a modsecurity_rules_file /etc/nginx/modsec/main.conf;' /etc/nginx/conf.d/default.conf; sed -i '/server {/a modsecurity on;' /etc/nginx/conf.d/default.conf; echo "Install OWASP CRS"; cd /usr/local; wget "https://github.com/SpiderLabs/owasp-modsecurity-crs/archive/v${OWASP_CRS_VERSION}.tar.gz"; tar -xzvf "v${OWASP_CRS_VERSION}.tar.gz"; rm "v${OWASP_CRS_VERSION}.tar.gz"; cd "owasp-modsecurity-crs-${OWASP_CRS_VERSION}"; cp crs-setup.conf.example crs-setup.conf; cp rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf; cp rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf.example rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf; echo "Configure ModSecurity"; mkdir /etc/nginx/modsec; wget -P "/etc/nginx/modsec/" "https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v${MOD_SECURITY_VERSION}/modsecurity.conf-recommended"; mv "/etc/nginx/modsec/modsecurity.conf-recommended" "/etc/nginx/modsec/modsecurity.conf"; wget -P "/etc/nginx/modsec/" "https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v${MOD_SECURITY_VERSION}/unicode.mapping"; sed -i "s/SecRuleEngine DetectionOnly/SecRuleEngine On/" "/etc/nginx/modsec/modsecurity.conf"; echo "# Include the recommended configuration" > /etc/nginx/modsec/main.conf; echo "Include /etc/nginx/modsec/modsecurity.conf" >> /etc/nginx/modsec/main.conf; echo "# OWASP CRS v3 rules" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/crs-setup.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/REQUEST-901-INITIALIZATION.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/REQUEST-905-COMMON-EXCEPTIONS.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/REQUEST-910-IP-REPUTATION.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/REQUEST-911-METHOD-ENFORCEMENT.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/REQUEST-912-DOS-PROTECTION.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/REQUEST-913-SCANNER-DETECTION.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/REQUEST-920-PROTOCOL-ENFORCEMENT.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/REQUEST-921-PROTOCOL-ATTACK.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/REQUEST-930-APPLICATION-ATTACK-LFI.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/REQUEST-931-APPLICATION-ATTACK-RFI.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/REQUEST-932-APPLICATION-ATTACK-RCE.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/REQUEST-933-APPLICATION-ATTACK-PHP.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/REQUEST-941-APPLICATION-ATTACK-XSS.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/REQUEST-942-APPLICATION-ATTACK-SQLI.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/REQUEST-949-BLOCKING-EVALUATION.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/RESPONSE-950-DATA-LEAKAGES.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/RESPONSE-951-DATA-LEAKAGES-SQL.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/RESPONSE-952-DATA-LEAKAGES-JAVA.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/RESPONSE-953-DATA-LEAKAGES-PHP.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/RESPONSE-954-DATA-LEAKAGES-IIS.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/RESPONSE-959-BLOCKING-EVALUATION.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/RESPONSE-980-CORRELATION.conf" >> /etc/nginx/modsec/main.conf; echo "Include /usr/local/owasp-modsecurity-crs-${OWASP_CRS_VERSION}/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf" >> /etc/nginx/modsec/main.conf; echo "Cleanup"; apt remove -y apt-utils autoconf automake build-essential git libcurl4-openssl-dev libgeoip-dev liblmdb-dev libpcre++-dev libtool libxml2-dev libyajl-dev pkgconf wget zlib1g-dev; rm -rf /var/lib/apt/lists/*
