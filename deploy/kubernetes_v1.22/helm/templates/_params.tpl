{{- define "configmap-sidecar.sidecar" -}}
{{print "{{- if or (isset .ObjectMeta.Annotations `polarismesh.cn/proxyCPU`) (isset .ObjectMeta.Annotations `polarismesh.cn/proxyMemory`) (isset .ObjectMeta.Annotations `polarismesh.cn/proxyCPULimit`) (isset .ObjectMeta.Annotations `polarismesh.cn/proxyMemoryLimit`) }}
  {{- if or (isset .ObjectMeta.Annotations `polarismesh.cn/proxyCPU`) (isset .ObjectMeta.Annotations `polarismesh.cn/proxyMemory`) }}
    requests:
      {{ if (isset .ObjectMeta.Annotations `polarismesh.cn/proxyCPU`) -}}
      cpu: \"{{ index .ObjectMeta.Annotations `polarismesh.cn/proxyCPU` }}\"
      {{ end }}
      {{ if (isset .ObjectMeta.Annotations `polarismesh.cn/proxyMemory`) -}}
      memory: \"{{ index .ObjectMeta.Annotations `polarismesh.cn/proxyMemory` }}\"
      {{ end }}
  {{- end }}
  {{- if or (isset .ObjectMeta.Annotations `polarismesh.cn/proxyCPULimit`) (isset .ObjectMeta.Annotations `polarismesh.cn/proxyMemoryLimit`) }}
    limits:
      {{ if (isset .ObjectMeta.Annotations `polarismesh.cn/proxyCPULimit`) -}}
      cpu: \"{{ index .ObjectMeta.Annotations `polarismesh.cn/proxyCPULimit` }}\"
      {{ end }}
      {{ if (isset .ObjectMeta.Annotations `polarismesh.cn/proxyMemoryLimit`) -}}
      memory: \"{{ index .ObjectMeta.Annotations `polarismesh.cn/proxyMemoryLimit` }}\"
      {{ end }}
  {{- end }}
{{- else }}
  {{- if .Values.global.proxy.resources }}
    {{ toYaml .Values.global.proxy.resources | indent 6 }}
  {{- end }}
{{- end }}"}}
{{- end -}}