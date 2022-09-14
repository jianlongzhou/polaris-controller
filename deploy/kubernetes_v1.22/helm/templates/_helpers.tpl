{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "polaris-controller.name" -}}
{{- default .Chart.Name .Values.controller.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "polaris-controller.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Polaris controller deployment labels
*/}}
{{- define "polaris-controller.controller.labels" -}}
qcloud-app: polaris-controller
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}


{{/*
Get specific image for controller
*/}}
{{- define "polaris-controller.controller.image" -}}
{{- printf "%s:%s" .Values.controller.image.repo .Values.controller.image.tag -}}
{{- end -}}

{{/*
Get specific image for sidecar
*/}}
{{- define "polaris-controller.sidecar.image" -}}
{{- printf "%s:%s" .Values.sidecar.image.repo .Values.sidecar.image.tag -}}
{{- end -}}


{{/*
Create a default fully qualified controller name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "polaris-controller.controller.fullname" -}}
{{- printf "%s-%s" (include "polaris-controller.fullname" .) .Values.controller.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Selector labels
*/}}
{{- define "polaris-controller.controller.selectorLabels" -}}
app.kubernetes.io/name: {{ include "polaris-controller.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: sidecar-injector
{{- end -}}

