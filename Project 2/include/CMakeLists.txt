add_library(COMMANDS STATIC commands.h commands.c)

# add_library(CLIENT STATIC client.h client.c)

# add_library(DECRYPT STATIC decrypt.h decrypt.c)
# target_link_libraries(DECRYPT PRIVATE OpenSSL::SSL OpenSSL::Crypto)

# add_library(ENCRYPT STATIC encrypt.h encrypt.c)
# target_link_libraries(ENCRYPT PRIVATE OpenSSL::SSL OpenSSL::Crypto)

# add_library(SERVER STATIC server.h server.c)