/**
 * login.js
 */

/* 전역 */
var CTX;
var loginPro;
var closeModal;

// ✅ 아이디 저장 기능
function initRememberId() {
  var userIdInput = document.querySelector('input[name="userId"]');
  var rememberCheckbox = document.querySelector('input[name="rememberId"]');
  
  if (!userIdInput || !rememberCheckbox) return;

  // 1️⃣ 페이지 로드 시 저장된 아이디 복구
  var savedId = localStorage.getItem('savedUserId');
  if (savedId) {
    userIdInput.value = savedId;
    rememberCheckbox.checked = true;
  }

  // 2️⃣ 로그인 폼 제출 시 아이디 저장/삭제
  var form = document.querySelector('form');
  if (form) {
    form.addEventListener('submit', function() {
      var userId = userIdInput.value.trim();
      
      if (rememberCheckbox.checked && userId) {
        localStorage.setItem('savedUserId', userId);
      } else {
        localStorage.removeItem('savedUserId');
      }
    });
  }
}

loginPro = function(){

  // 태그 찾기
  var idLink = document.getElementById("findIdLink");
  var pwLink = document.getElementById("findPwLink");

  var bg    = document.getElementById("fModalBg");
  var modal = document.getElementById("fModal");
  var title = document.getElementById("fModalTitle");
  var frame = document.getElementById("fModalFrame");
  var close = document.getElementById("fModalClose");

  // 하나라도 없으면 종료
  if(!idLink || !pwLink || !bg || !modal || !title || !frame || !close){
    return;
  }

  // ✅ 아이디 저장 기능 초기화
  initRememberId();

  // 모달 열기
  var openModal = function(tt, url){
    title.textContent = tt;
    frame.setAttribute("src", url);
    bg.style.display = "block";
    modal.style.display = "flex";
  };

  // ✅ 모달 닫기
  var closeModal = function(){
    frame.setAttribute("src", "");
    bg.style.display = "none";
    modal.style.display = "none";
  };

  window.closeModal = closeModal;

  // ✅ iframe에서 parent.closeModal()로 호출할 수 있게 전역으로 공개

  // 아이디 찾기
  idLink.addEventListener("click", function(e){
    e.preventDefault();
    openModal("아이디 찾기", CTX + "/findId.do");
  });
  

  // 비밀번호 찾기
  pwLink.addEventListener("click", function(e){
    e.preventDefault();
    openModal("비밀번호 찾기", CTX + "/findPw.do");
  });

  // 닫기
  close.addEventListener("click", closeModal);
  bg.addEventListener("click", closeModal);
};