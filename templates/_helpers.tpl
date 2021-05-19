{{/*
Expand the name of the chart.
*/}}
{{- define "cortex.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cortex.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Name the Play framework secret.
*/}}
{{- define "cortex.playsecretname" -}}
{{ include "cortex.fullname" . -}} -play-secret
{{- end }}

{{/*
Name the extra config secret
*/}}
{{- define "cortex.extraconfigsecret" -}}
{{ include "cortex.fullname" . -}} -extra-config
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cortex.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cortex.labels" -}}
helm.sh/chart: {{ include "cortex.chart" . }}
{{ include "cortex.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cortex.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cortex.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cortex.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cortex.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the persistent volume claim to use for job I/O
*/}}
{{- define "cortex.jobIOPVC" -}}
{{ printf "%s-job-io" (include "cortex.fullname" .) }}
{{- end }}

{{/*
If the Cortex entrypoint default value of JOB_DIRECTORY changes, change this
*/}}
{{- define "cortex.jobDir" -}}
/tmp/cortex-jobs
{{- end }}

{{- define "cortex.templatesConfigMapName" -}}
{{ printf "%s-etc-c-tmpl" (include "cortex.fullname" .) }}
{{- end }}