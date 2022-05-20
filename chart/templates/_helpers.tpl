{{- define "badgr.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  Create a default fully qualified orc name.
  We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "badgr.fullname" -}}
{{- printf "%s-%s" .Release.Name .Values.serverName | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
  Create chart name and version as used by the chart label.
*/}}
{{- define "badgr.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
  Selector labels orc
*/}}
{{- define "badgr.selectorLabels" -}}
app.kubernetes.io/name: {{ include "badgr.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
deploymentconfig: {{ include "badgr.fullname" . }}
{{- end -}}


{{/*
  Common labels
*/}}
{{- define "badgr.labels" -}}
helm.sh/chart: {{ include "badgr.chart" . }}
{{ include "badgr.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the image to build
*/}}
{{- define "badgr-server.image_name" -}}
{{- if eq .Values.image_repository "azurecr.io" }}
{{- .Values.image_namespace }}.{{ .Values.image_repository }}/{{ .Values.image_name }}:{{ .Values.image_tag -}}
{{- else }}
{{- .Values.image_repository }}/{{ .Values.image_namespace | default .Release.Namespace }}/{{ .Values.image_name }}:{{ .Values.image_tag -}}
{{- end }}
{{- end }}