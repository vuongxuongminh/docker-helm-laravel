{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/* Helm required labels */}}
{{- define "labels" -}}
heritage: {{ .Release.Service }}
release: {{ .Release.Name }}
chart: {{ .Chart.Name }}
app: "{{ template "name" . }}"
{{- end -}}

{{/* matchLabels */}}
{{- define "matchLabels" -}}
release: {{ .Release.Name }}
app: "{{ template "name" . }}"
{{- end -}}

{{- define "php" -}}
  {{- printf "%s-php" (include "fullname" .) -}}
{{- end -}}

{{- define "fpm" -}}
  {{- printf "%s-fpm" (include "fullname" .) -}}
{{- end -}}

{{- define "supervisor" -}}
  {{- printf "%s-supervisor" (include "fullname" .) -}}
{{- end -}}

{{- define "nginx" -}}
  {{- printf "%s-nginx" (include "fullname" .) -}}
{{- end -}}

{{- define "hook" -}}
    {{- printf "%s-hook" (include "fullname" .) -}}
{{- end -}}

{{- define "databaseHost" -}}
  {{- if .Values.mysql.internal }}
    {{- .Values.mysql.fullnameOverride -}}
  {{- else }}
    {{- .Values.mysql.externalHost -}}
  {{- end }}
{{- end -}}

{{- define "databasePort" -}}
  {{- if .Values.mysql.internal }}
    {{- .Values.mysql.service.port -}}
  {{- else }}
    {{- .Values.mysql.externalPort -}}
  {{- end }}
{{- end -}}

{{- define "databaseUser" -}}
  {{- if .Values.mysql.internal }}
    {{- .Values.mysql.mysqlUser -}}
  {{- else }}
    {{- .Values.mysql.externalUser -}}
  {{- end }}
{{- end -}}

{{- define "databasePassword" -}}
  {{- if .Values.mysql.internal }}
    {{- .Values.mysql.mysqlPassword -}}
  {{- else }}
    {{- .Values.mysql.externalPassword -}}
  {{- end }}
{{- end -}}

{{- define "databaseName" -}}
  {{- if .Values.mysql.internal }}
    {{- .Values.mysql.mysqlDatabase -}}
  {{- else }}
    {{- .Values.mysql.externalDatabase -}}
  {{- end }}
{{- end -}}

{{- define "rabbitMQHost" -}}
  {{- if .Values.rabbitmq.internal }}
    {{- .Values.rabbitmq.fullnameOverride -}}
  {{- else }}
    {{- .Values.rabbitmq.externalHost -}}
  {{- end }}
{{- end -}}

{{- define "rabbitMQPort" -}}
  {{- if .Values.rabbitmq.internal }}
    {{- .Values.rabbitmq.service.port -}}
  {{- else }}
    {{- .Values.rabbitmq.externalPort -}}
  {{- end }}
{{- end -}}

{{- define "rabbitMQUser" -}}
  {{- if .Values.rabbitmq.internal }}
    {{- .Values.rabbitmq.rabbitmq.username -}}
  {{- else }}
    {{- .Values.rabbitmq.externalUser -}}
  {{- end }}
{{- end -}}

{{- define "rabbitMQPassword" -}}
  {{- if .Values.rabbitmq.internal }}
    {{- .Values.rabbitmq.rabbitmq.password -}}
  {{- else }}
    {{- .Values.rabbitmq.externalPassword -}}
  {{- end }}
{{- end -}}