-- ============================================================
-- KnovaQ: Seed ragflow user + sys_config for session auth
-- User: admin / admin@163.com / admin123
--
-- Auth flow:
--   gaisoft-mes sends RSA-encrypted password from sys_config
--   ragflow login: decrypt(RSA) -> base64('admin123') -> check_password_hash(stored_hash, base64_value)
--   So stored hash must match 'YWRtaW4xMjM=' (base64 of 'admin123')
--
-- Run: docker cp seed-ragflow-user.sql ragflow-mysql:/tmp/
--      docker exec ragflow-mysql mysql -uroot -pinfini_rag_flow -e "source /tmp/seed-ragflow-user.sql"
-- ============================================================

-- 1. Insert ragflow user (rag_flow.user)
-- Password hash: scrypt of 'YWRtaW4xMjM=' (base64('admin123'))
-- This matches the ragflow login flow: RSA decrypt -> base64 string -> check_password_hash
INSERT INTO rag_flow.`user` (
    id, create_time, create_date, update_time, update_date,
    nickname, email, password,
    language, color_schema, timezone,
    last_login_time, login_channel,
    status, is_authenticated, is_active, is_anonymous, is_superuser
) VALUES (
    'a0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5',
    UNIX_TIMESTAMP(NOW())*1000, NOW(), UNIX_TIMESTAMP(NOW())*1000, NOW(),
    'admin', 'admin@163.com',
    'scrypt:32768:8:1$g8VrRbnYtWVbyVQT$387817b9d12059bdbe599f7ecf4aef1ef0bad9e1032d54ce4830970469b597761f7cdefb1e1c8131e4a965698e7eb1a856a8fbbf4c35d72aa89ad2d09a913e16',
    'zh', 'bright', 'UTC+8',
    NULL, NULL,
    '1', '1', '1', '0', 1
) ON DUPLICATE KEY UPDATE
    password = VALUES(password),
    nickname = 'admin',
    status = '1',
    is_active = '1',
    is_superuser = 1;

-- 2. Insert tenant (rag_flow.tenant)
-- tenant.id = user.id (ragflow convention)
INSERT INTO rag_flow.`tenant` (
    id, create_time, create_date, update_time, update_date,
    name, public_key,
    llm_id, embd_id, asr_id, img2txt_id, rerank_id, tts_id,
    parser_ids, credit, status
) VALUES (
    'a0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5',
    UNIX_TIMESTAMP(NOW())*1000, NOW(), UNIX_TIMESTAMP(NOW())*1000, NOW(),
    'admin Kingdom', NULL,
    '', 'BAAI/bge-large-zh-v1.5@BAAI', '', '', '', NULL,
    'naive:General,qa:Q&A,resume:Resume,manual:Manual,table:Table,paper:Paper,book:Book,laws:Laws,presentation:Presentation,picture:Picture,one:One,audio:Audio,email:Email,tag:Tag',
    512, '1'
) ON DUPLICATE KEY UPDATE
    embd_id = VALUES(embd_id),
    parser_ids = VALUES(parser_ids),
    status = '1';

-- 3. Insert user_tenant (rag_flow.user_tenant)
INSERT INTO rag_flow.`user_tenant` (
    id, create_time, create_date, update_time, update_date,
    user_id, tenant_id, role, invited_by, status
) VALUES (
    'a0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5',
    UNIX_TIMESTAMP(NOW())*1000, NOW(), UNIX_TIMESTAMP(NOW())*1000, NOW(),
    'a0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5',
    'a0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5',
    'owner',
    'a0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5',
    '1'
) ON DUPLICATE KEY UPDATE
    role = 'owner',
    status = '1';

-- 3.5 Register bundled local embedding model into tenant_llm (BAAI/bge-large-zh-v1.5)
-- ragflow 0.18.0 full image ships this model locally at /root/.ragflow (no API key needed).
-- SQL-seeded users skip ragflow's auto-registration, so add it explicitly; matches tenant.embd_id above.
INSERT INTO rag_flow.`tenant_llm` (
    create_time, create_date, update_time, update_date,
    tenant_id, llm_factory, model_type, llm_name, api_key, api_base, max_tokens, used_tokens
) VALUES (
    UNIX_TIMESTAMP(NOW())*1000, NOW(), UNIX_TIMESTAMP(NOW())*1000, NOW(),
    'a0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5', 'BAAI', 'embedding', 'BAAI/bge-large-zh-v1.5', '', '', 1024, 0
) ON DUPLICATE KEY UPDATE api_key = '';

-- 3.6 Register API key (rag_flow.api_token) so gaisoft sys_config.RagFlowKey is valid for /api/v1/*
-- Token must match equipment_iqas.sys_config 'RagFlowKey' (ragflow-E5ODdhM2I2MTZiMjExZjBiMGU3NjJhM2).
INSERT INTO rag_flow.`api_token` (
    create_time, create_date, update_time, update_date,
    tenant_id, token, dialog_id, source, beta
) VALUES (
    UNIX_TIMESTAMP(NOW())*1000, NOW(), UNIX_TIMESTAMP(NOW())*1000, NOW(),
    'a0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5', 'ragflow-E5ODdhM2I2MTZiMjExZjBiMGU3NjJhM2', NULL, NULL, NULL
) ON DUPLICATE KEY UPDATE update_time = UNIX_TIMESTAMP(NOW())*1000;

-- 4. Update sys_config in equipment_iqas
-- email: plaintext (sent as-is in JSON)
-- password: RSA-encrypted with ragflow's conf/public.pem (sent as-is, ragflow decrypts)
UPDATE equipment_iqas.sys_config
    SET config_value = 'admin@163.com', update_time = NOW()
    WHERE config_key = 'email';

UPDATE equipment_iqas.sys_config
    SET config_value = 'exDI+XVG9Ug/y2zhQlGtcclYEwgd7Eg8GDLAoKWbdmBHJ0nR8yXD+k1ID0VjVXFVZ8oy2nfffYQOobho/RKJKBOjPjShomQlbG0eV34yH18Ckreh5Y6XRZQUDQYMgX9YLOSQzq5MIjrsP+TfOBBVp8wm1R19ih/DatfHVtRp1tAPX9J3SOXcuWuJfxeVgb5BfZSjitO6H9zS+GLvvHHP888h6YprRrIEZuxwnLR1HJm/RJZkG8j7ZyBGKznMc20nkuCy9PUg6ptL2AHyReWeWjuSNhxGl9LyIAf1uA9d76MU3VtIWBtZwU9SK7MPt1KnDjQkTI+kvlrIk4M3MJglYg==',
    update_time = NOW()
    WHERE config_key = 'password';

-- ============================================================
-- Verify
-- ============================================================
SELECT '--- ragflow user ---' AS info;
SELECT id, nickname, email, status, is_superuser FROM rag_flow.`user` WHERE email='admin@163.com';

SELECT '--- ragflow tenant ---' AS info;
SELECT id, name, embd_id, credit, status FROM rag_flow.`tenant` WHERE id='a0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5';

SELECT '--- user_tenant ---' AS info;
SELECT id, user_id, tenant_id, role, status FROM rag_flow.`user_tenant` WHERE user_id='a0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5';

SELECT '--- sys_config auth ---' AS info;
SELECT config_key, LEFT(config_value, 40) AS config_value FROM equipment_iqas.sys_config WHERE config_key IN ('email','password','RagFlowKey','RagFlowServerBaseUrl');
