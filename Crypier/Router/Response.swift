
import Foundation

class Response<T> {
    
    private var _error: ErrorMessage? = nil
    private var _data: T? = nil
    
    init(data: T) {
        self._data = data;
    }
    
    init(error: ErrorMessage) {
        self._error = error;
    }
    
    var hasError : Bool {
        return _error != nil
    }
    
    var data: T {
        return self._data!;
    }
    
    var error: ErrorMessage {
        return self._error!;
    }
    
    func passError<R>() -> Response<R> {
        return Response<R>(error: self.error);
    }
    
    func passSuccess<R>(_ map: (T)->R) -> Response<R> {
        return Response<R>(data: map(self.data))
    }
    
    func pass<R>(_ map: (T)->R) -> Response<R> {
        if self.hasError {
            return self.passError();
        }
        return self.passSuccess(map);
    }
}
