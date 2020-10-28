{{/*
创建一个默认的应用名称，截取63个字符是因为 Kubernetes 的 name 属性的限制（DNS 命名规范）。
*/}}
{{- define "wordpress.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
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
mysql 子 chart 的名称定义
*/}}
{{- define "mysql.fullname" -}}
{{- printf "%s-mysql" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "wordpress.externaldbSecret" -}}
{{ printf "%s-%s" .Release.Name "externaldb" }}
{{- end -}}