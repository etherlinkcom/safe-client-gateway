#!/usr/bin/env sh
set -eu

output_dir="$(CDPATH= cd -- "$(dirname -- "$0")/../db_config/test" && pwd)"
key_path="$output_dir/server.key"
certificate_path="$output_dir/server.crt"

if ! command -v openssl >/dev/null 2>&1; then
  printf '%s\n' 'OpenSSL is required to generate the local PostgreSQL test certificate.' >&2
  exit 1
fi

rm -f "$key_path" "$certificate_path"
openssl req \
  -x509 \
  -nodes \
  -newkey rsa:2048 \
  -sha256 \
  -days "${TLS_VALIDITY_DAYS:-365}" \
  -keyout "$key_path" \
  -out "$certificate_path" \
  -subj '/CN=localhost' \
  -addext 'subjectAltName=DNS:localhost'

chmod 0600 "$key_path"
printf 'Generated local PostgreSQL TLS assets under %s\n' "$output_dir"
