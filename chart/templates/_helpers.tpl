{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mysql.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mysql.fullname" -}}
{{- if .Values.fullnameOverrideDb -}}
{{- printf "%s-%s" .Values.fullnameOverrideDb .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Generate chart secret name
*/}}
{{- define "mysql.secretName" -}}
{{ default (include "mysql.fullname" .) .Values.existingSecret }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "mysql.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{ default (include "mysql.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
{{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
  ********************************************************************************************************
*/}}
{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "project.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  Create a short orc name.
  We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "badgr.name" -}}
{{- printf "%s-%s" .Chart.Name .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  Create a default fully qualified orc name.
  We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "badgr.fullname" -}}
{{- printf "%s-%s" .Release.Name .Values.serverName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "badgr.labels" -}}
helm.sh/chart: {{ include "project.chart" . }}
{{ include "badgr.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
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
  ********************************************************************************************************
*/}}
