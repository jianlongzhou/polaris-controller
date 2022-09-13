{{- define "configmap-sidecar.args" -}}
- istio-iptables
- -p
- "15001"
- -u
- "1337"
- -m
- REDIRECT
- -i
- "10.4.4.4/32"
- -b
- "{{ "{{" }} (annotation .ObjectMeta `polarismesh.cn/includeInboundPorts` ``) {{ "}}" }}"
- -x
- "{{ "{{" }} (annotation .ObjectMeta `polarismesh.cn/excludeOutboundCIDRs` ``) {{ "}}" }}"
- -d
- "{{ "{{" }} (annotation .ObjectMeta `polarismesh.cn/excludeInboundPorts` ``) {{ "}}" }}"
- -o
- "{{ "{{" }} (annotation .ObjectMeta `polarismesh.cn/excludeOutboundPorts` ``) {{ "}}" }}"
- --redirect-dns=true
{{- end -}}

{{- define "configmap-sidecar.envs" -}}
- name: NAMESPACE
  valueFrom:
    fieldRef:
      fieldPath: metadata.namespace
- name: POLARIS_SERVER_URL
  value: {{ "{{" }}.ProxyConfig.ProxyMetadata.serverAddress{{ "}}" }}:15010
- name: CLUSTER_NAME
  value: {{ "{{" }}.ProxyConfig.ProxyMetadata.clusterName{{ "}}" }}
{{- end -}}

{{- define "configmap-sidecar.resources" -}}
{{ "{{" }}- if or (isset .ObjectMeta.Annotations `polarismesh.cn/proxyCPU`) (isset .ObjectMeta.Annotations `polarismesh.cn/proxyMemory`) (isset .ObjectMeta.Annotations `polarismesh.cn/proxyCPULimit`) (isset .ObjectMeta.Annotations `polarismesh.cn/proxyMemoryLimit`) {{ "}}" }}
  {{ "{{" }}- if or (isset .ObjectMeta.Annotations `polarismesh.cn/proxyCPU`) (isset .ObjectMeta.Annotations `polarismesh.cn/proxyMemory`) {{ "}}" }}
    requests:
      {{ "{{" }} if (isset .ObjectMeta.Annotations `polarismesh.cn/proxyCPU`) -{{ "}}" }}
      cpu: "{{ "{{" }} index .ObjectMeta.Annotations `polarismesh.cn/proxyCPU` {{ "}}" }}"
      {{ "{{" }} end {{ "}}" }}
      {{ "{{" }} if (isset .ObjectMeta.Annotations `polarismesh.cn/proxyMemory`) -{{ "}}" }}
      memory: "{{ "{{" }} index .ObjectMeta.Annotations `polarismesh.cn/proxyMemory` {{ "}}" }}"
      {{ "{{" }} end {{ "}}" }}
  {{ "{{" }}- end {{ "}}" }}
  {{ "{{" }}- if or (isset .ObjectMeta.Annotations `polarismesh.cn/proxyCPULimit`) (isset .ObjectMeta.Annotations `polarismesh.cn/proxyMemoryLimit`) {{ "}}" }}
    limits:
      {{ "{{" }} if (isset .ObjectMeta.Annotations `polarismesh.cn/proxyCPULimit`) -{{ "}}" }}
      cpu: "{{ "{{" }} index .ObjectMeta.Annotations `polarismesh.cn/proxyCPULimit` {{ "}}" }}"
      {{ "{{" }} end {{ "}}" }}
      {{ "{{" }} if (isset .ObjectMeta.Annotations `polarismesh.cn/proxyMemoryLimit`) -{{ "}}" }}
      memory: "{{ "{{" }} index .ObjectMeta.Annotations `polarismesh.cn/proxyMemoryLimit` {{ "}}" }}"
      {{ "{{" }} end {{ "}}" }}
  {{ "{{" }}- end {{ "}}" }}
{{ "{{" }}- else {{ "}}" }}
  {{ "{{" }}- if .Values.global.proxy.resources {{ "}}" }}
    {{ "{{" }} toYaml .Values.global.proxy.resources | indent 6 {{ "}}" }}
  {{ "{{" }}- end {{ "}}" }}
{{ "{{" }}- end {{ "}}" }}
{{- end -}}