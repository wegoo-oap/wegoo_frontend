Get-ChildItem -Path lib, test -Filter *.dart -Recurse | ForEach-Object {
    $text = Get-Content $_.FullName -Raw;
    $text = $text -replace 'wegoo/features/auth/screens/', 'wegoo/features/auth/views/'
    $text = $text -replace 'wegoo/features/profile/screens/', 'wegoo/features/profile/views/'
    $text = $text -replace 'wegoo/core/services/api_client.dart', 'wegoo/core/network/api_client.dart'
    $text = $text -replace 'wegoo/core/services/auth_service.dart', 'wegoo/features/auth/services/auth_service.dart'
    $text = $text -replace 'wegoo/core/router/app_router.dart', 'wegoo/core/routing/app_router.dart'
    $text = $text -replace 'wegoo/core/models/user_model.dart', 'wegoo/features/profile/models/user_model.dart'
    $text = $text -replace 'wegoo/core/services/user_repository.dart', 'wegoo/features/profile/services/user_repository.dart'
    $text = $text -replace 'wegoo/core/models/chat_model.dart', 'wegoo/features/chat/models/chat_model.dart'
    $text = $text -replace 'wegoo/core/models/match_model.dart', 'wegoo/features/swipe/models/match_model.dart'
    $text = $text -replace 'wegoo/core/models/message_model.dart', 'wegoo/features/chat/models/message_model.dart'
    $text = $text -replace 'wegoo/core/services/chat_repository.dart', 'wegoo/features/chat/services/chat_repository.dart'
    [IO.File]::WriteAllText($_.FullName, $text, [Text.Encoding]::UTF8);
}
