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
