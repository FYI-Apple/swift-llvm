; Check if "RtLibUseGOT" works correctly when lib calls are simplified.
; RUN: opt < %s -instcombine -S | FileCheck %s

@percent_s = constant [4 x i8] c"%s\0A\00"
@hello_world = constant [13 x i8] c"hello world\0A\00"
declare i32 @printf(i8*, ...)
define void @printf_call() {
  %fmt = getelementptr [4 x i8], [4 x i8]* @percent_s, i32 0, i32 0
  %str = getelementptr [13 x i8], [13 x i8]* @hello_world, i32 0, i32 0
  call i32 (i8*, ...) @printf(i8* %fmt, i8* %str)
; CHECK:  call i32 @puts(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @hello_world, i64 0, i64 0))
  ret void
}

; CHECK: Function Attrs: nofree nounwind nonlazybind
; CHECK-NEXT: declare i32 @puts(i8* nocapture readonly)

!llvm.module.flags = !{!0}
!0 = !{i32 7, !"RtLibUseGOT", i32 1}
