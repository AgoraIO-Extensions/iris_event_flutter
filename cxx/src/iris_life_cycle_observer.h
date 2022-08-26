#include <functional>

namespace agora {
namespace iris {

class ILifeCycleObserver {

 public:
  ILifeCycleObserver(std::function<void()> cb);
  void addApplicationObserver();
  void removeApplicationObserver();

 private:
  void *applicationWillTerminateObserver;
  std::function<void()> callback_;
};
}// namespace iris
}// namespace agora