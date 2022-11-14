#ifndef IRIIS_EVENT_H_
#define IRIIS_EVENT_H_

#include "dart_api.h"

#ifdef _WIN32
#define EXPORT __declspec(dllexport)
#else
#define EXPORT __attribute__((visibility("default")))
#endif

#define kBasicResultLength 64 * 1024

#ifdef __cplusplus
extern "C"
{
#endif
    typedef struct EventParam
    {
        const char *event;
        const char *data;
        unsigned int data_size;
        char *result;
        const void **buffer;
        unsigned int *length;
        unsigned int buffer_count;
    } EventParam;

    // Initialize `dart_api_dl.h`
    EXPORT intptr_t Initialize(void *data);

    EXPORT void Dispose();

    EXPORT void OnEvent(EventParam *param);

    EXPORT void OnEventLegacy(const char *event, const char *data,
                              const void **buffer, unsigned int *length,
                              unsigned int buffer_count);

    EXPORT void OnEventExLegacy(const char *event, const char *data,
                                char result[kBasicResultLength],
                                const void **buffer, unsigned int *length,
                                unsigned int buffer_count);

    EXPORT void RegisterDartPort(Dart_Port send_port);

    EXPORT void UnregisterDartPort(Dart_Port send_port);

#ifdef __cplusplus
}
#endif

#endif // IRIS_EVENT_H_
