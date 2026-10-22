#!/bin/sh
set -e

# Sane defaults for local container execution or fallback (use 127.0.0.1 to avoid DNS resolution crashes on un-deployed services)
export PORT="${PORT:-80}"
export AUTH_URL="${AUTH_URL:-http://127.0.0.1:8000}"
export PROFILE_URL="${PROFILE_URL:-http://127.0.0.1:8000}"
export CHALLENGE_URL="${CHALLENGE_URL:-http://127.0.0.1:8000}"
export APPLICATION_URL="${APPLICATION_URL:-http://127.0.0.1:8000}"
export MODERATION_URL="${MODERATION_URL:-http://127.0.0.1:8000}"
export NOTIFICATION_URL="${NOTIFICATION_URL:-http://127.0.0.1:8000}"
export FRONTEND_URL="${FRONTEND_URL:-http://127.0.0.1:3000}"

# If templates exist and conf.d is writable (e.g. in Cloud Run / standalone container),
# render default.conf from template.
if [ -f /etc/nginx/templates/default.conf.template ]; then
    if touch /etc/nginx/conf.d/.write_test 2>/dev/null; then
        rm -f /etc/nginx/conf.d/.write_test
        echo "Rendering /etc/nginx/conf.d/default.conf with PORT=${PORT}..."
        envsubst '${PORT} ${AUTH_URL} ${PROFILE_URL} ${CHALLENGE_URL} ${APPLICATION_URL} ${MODERATION_URL} ${NOTIFICATION_URL} ${FRONTEND_URL}' \
            < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf
    else
        echo "Mounted /etc/nginx/conf.d is read-only. Skipping template rendering and using existing configuration..."
    fi
fi

exec "$@"
