{{/*
Expand the name of the chart.
*/}}
{{- define "quorumNode.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "quorumNode.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default ( include "quorumNode.Identifier" . ) .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "quorumNode.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "quorumNode.labels" -}}
helm.sh/chart: {{ include "quorumNode.chart" . }}
{{ include "quorumNode.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "quorumNode.selectorLabels" -}}
app.kubernetes.io/name: {{ include "quorumNode.Identifier" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "quorumNode.Identifier" -}}
{{- $name := (include "quorumNode.name" .) }}
{{- if .Values.deployment.quorum_node_no }}
{{- printf "%s-%s" $name .Values.deployment.quorum_node_no | trunc 63 }}
{{- else }}
{{- printf "%s" $name | trunc 63 }}
{{- end }}
{{- end }}


{{- define "quorumnode.PvcLogs" -}}
{{- if .Values.persistence.logs.existingClaim }}
{{- .Values.persistence.logs.existingClaim }}
{{- else }}
{{- $qni := include "quorumNode.Identifier" . }}
{{- printf "%s-logs" $qni }}
{{- end }}
{{- end }}

{{- define "quorumnode.PvcData" -}}
{{- if .Values.persistence.data.existingClaim }}
{{- .Values.persistence.data.existingClaim }}
{{- else }}
{{- $qni := include "quorumNode.Identifier" . }}
{{- printf "%s-data" $qni }}
{{- end }}
{{- end }}

{{- define "quorumnode.permissionedNodes" -}}
{{- $qni := include "quorumNode.Identifier" . }}
{{- printf "%s-permissioned-nodes" $qni }}
{{- end }}

{{- define "quorumnode.NodeManagement" -}}
{{- $qni := include "quorumNode.Identifier" . }}
{{- printf "%s-node-management" $qni }}
{{- end }}

{{- define "quorumnode.IValidatorCfg" -}}
{{- $qni := include "quorumNode.Identifier" . }}
{{- printf "%s-istanbul-validator-config" $qni }}
{{- end }}

{{- define "quorumnode.gethHelpers" -}}
{{- $qni := include "quorumNode.Identifier" . }}
{{- printf "%s-geth-helpers" $qni }}
{{- end }}

{{/*
    The full image repository:tag[@sha256:sha]
*/}}
{{- define "quorumnode.image" -}}
{{- if .Values.image.sha -}}
{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}@sha256:{{ .Values.image.sha }}
{{- else -}}
{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}
{{- end -}}
{{- end -}}