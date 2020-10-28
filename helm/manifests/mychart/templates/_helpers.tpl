{{/* 生成基本的 Labels 标签 */}}
{{- define "mychart.labels" }}
  labels:
    generator: helm
    date: {{ now | htmlDate }}
    chart: {{ .Chart.Name }}
    release: {{ .Release.Name }}
{{- end }}


{{/*尽量使用include函数，而不是template*/}}
{{- define "mychart.app" -}}
app_name: {{ .Chart.Name }}
app_version: {{ .Chart.Version |quote }}
{{- end -}}