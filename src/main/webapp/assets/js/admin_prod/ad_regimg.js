console.log("ad_regimg.js loaded", "contextPath =", window.contextPath || contextPath);

/* =========================================================
   ✅ NEW 폼 드래프트(입력값) 저장/복원 유틸
   - loadRegImg로 전체 재렌더링해도 NEW 폼이 사라지지 않게 함
========================================================= */
const __newImgDrafts = new Map(); // key: regId, value: [{imgPath, viewSequence, originName},...]

function saveNewDrafts(regId, root){
  if(!regId || !root) return;

  const form = root.querySelector("form.img-update-form") || root.closest("form.img-update-form");
  if(!form) return;

  const drafts = Array.from(form.querySelectorAll('.img-form-item[data-mode="new"]'))
    .map(card => ({
      draftId: card.dataset.draftid || "", // ✅ (추가)
      imgPath: card.querySelector('input[name="newImgPath"]')?.value?.trim() || "",
      viewSequence: card.querySelector('input[name="newViewSequence"]')?.value?.trim() || "",
      originName: card.querySelector('input[name="newOriginName"]')?.value?.trim() || ""
    }))
    .filter(d => d.imgPath || d.viewSequence || d.originName);

  __newImgDrafts.set(String(regId), drafts);
}


function restoreNewDrafts(regId, root){
  if(!regId || !root) return;

  const form = root.querySelector("form.img-update-form") || root.closest("form.img-update-form");
  if(!form) return;

  const drafts = __newImgDrafts.get(String(regId)) || [];
  if(drafts.length === 0) return;

  drafts.forEach(d => {
    const newHtml = renderNewImgForm(regId);
    form.insertAdjacentHTML("beforeend", newHtml);

    const cards = form.querySelectorAll('.img-form-item[data-mode="new"]');
    const card = cards[cards.length - 1];

    // ✅ (추가) draftId 복원 (핵심)
    if(d.draftId) card.dataset.draftid = d.draftId;

    const p = card.querySelector('input[name="newImgPath"]');
    const s = card.querySelector('input[name="newViewSequence"]');
    const o = card.querySelector('input[name="newOriginName"]');

    if(p) p.value = d.imgPath || "";
    if(s) s.value = d.viewSequence || "";
    if(o) o.value = d.originName || "";

    if(p) p.dispatchEvent(new Event("input", { bubbles: true }));
  });
}

// <이미지 관리>탭 동작 함수
async function loadRegImg(regId){
	// id="tab-img-${regId}"인 div중 class="async-container"를 가져온다
	const box =
		document.querySelector("#tab-img-" + regId + " .async-container");

	if(!box) return; // box가 없으면 종료

	if (box.dataset.loaded == null) box.dataset.loaded = "0";
	if(box.dataset.loaded === "1") return; // 이미 로드됐을시 재호출 방지

	// ✅ (추가) 재렌더 전에 NEW 입력값 저장
	saveNewDrafts(regId, box);

	box.innerHTML = "로딩 중..";

	//console.log("POOL FETCH URL =", url);
	const resp = await fetch(
	  contextPath + "/adRegImgList.do?regId=" + encodeURIComponent(regId)
	);

	if(!resp.ok){
	  const txt = await resp.text();
	  console.error("POOL HTTP ERROR", resp.status, txt.slice(0, 200));
	  throw new Error("POOL HTTP " + resp.status);
	}

	const json = await resp.json();	// json() parsing 시간이 길어서 비동기 사용

	if(!json.ok){
		box.innerHTML = json.message || "조회 실패";
		return;
	}

	// 렌더링 함수 호출 및 출력
	const headerHTML = `<form id="updateForm" class="img-update-form">
						 <div><label style="font-size: 15px; color: #000;">상품등록코드&nbsp&nbsp:&nbsp&nbsp${regId}</label></div>
					 	  <input type="hidden" name="regId" value="${regId}" />`; // regId도 폼 데이터에 포함

	const bodyHTML = json.data.map((img, idx) => renderImgForm(regId, img, idx)).join("");

	const footerHTMl= `<div class="form-actions">
	   				    	 <div class="left">
	     				   		<button type="button" class="btnX danger btn-img-delete" data-regid="${regId}">
	           					등록삭제
	          			   		</button>
	        		         </div>

							 <div class="right" style="display:flex; gap:10px; align-items:center;">
	          					<button type="button" class="btnX gray md btn-cancel" data-regid="${regId}">취소</button>
	          					<button type="button" class="btnX green md btn-regimg-add" data-regid="${regId}">NEW</button>
	        			 	 </div>
	      				</div>
					</form>`;

	box.innerHTML = headerHTML + bodyHTML + footerHTMl;

	// ✅ (추가) 재렌더 후 NEW 입력값 복원
	restoreNewDrafts(regId, box);

	box.dataset.loaded = "1"; // 로드 상태값 설정
}


// 이미지 관리탭 bodyHTML내용 렌더링 함수
function renderImgForm(regId, img, idx) {
    const cp = typeof contextPath !== 'undefined' ? contextPath : '';
    const imgSrc = img.imgPath ? (cp + img.imgPath) : '';

    return `
        <div class="img-form-item" style="display: flex; gap: 24px; border: 1px solid #eef2f7;
                    border-radius: 16px; padding: 20px; background: #fff; margin-bottom: 10px;
                    box-shadow: 0 2px 8px rgba(0,0,0,0.02); position: relative;
                    height: 280px; align-items: stretch;"> <div style="display: flex; align-items: center; padding-right: 10px; border-right: 1px dashed #eee;">
				<input type="checkbox" name="selectedImg" value="${img.mapNo}"
				    style="width: 20px; height: 20px; cursor: pointer; accent-color: #4e73df;">
            </div>

            <div style="flex: 1.5; display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px;">
                <div>
                    <label style="display:block; font-size: 11px; color: #888; margin-bottom: 2px;">이미지순서</label>

					<div style="display:flex; gap:8px; align-items:center;">
					    <input type="number"
					           name="viewSequence"
					           class="inp-view-seq"
					           value="${img.viewSequence ?? "1"}"
					           min="1"
					           style="flex:1; padding:8px; border:1px solid #e9ecef; border-radius:8px; background:#fff; font-size:13px;"/>

					    <button type="button"
					            class="btnX indigo sm btn-viewseq-apply"
					            data-regid="${regId}"
					            data-mapno="${img.mapNo}"
					            style="height:34px; padding:0 12px; border-radius:10px; white-space:nowrap;">
					      적용
					    </button>
					</div>
                </div>

                <div>
                    <label style="display:block; font-size: 11px; color: #888; margin-bottom: 2px;">원본이미지명</label>
                    <input type="text" name="originName" value="${img.originName ?? ""}" disabled style="width:100%; padding:8px; border:1px solid #e9ecef; border-radius:8px; background:#f8f9fa; font-size:13px;"/>
                </div>

                <div style="grid-column: span 2;">
                    <label style="display:block; font-size: 11px; color: #888; margin-bottom: 2px;">이미지경로</label>
                    <input type="text" name="imgPath" value="${img.imgPath ?? ""}" disabled style="width:100%; padding:8px; border:1px solid #e9ecef; border-radius:8px; background:#f8f9fa; font-size:13px;"/>
                </div>

                <div>
                    <label style="display:block; font-size: 11px; color: #888; margin-bottom: 2px;">이미지코드</label>
                    <input type="text" name="imgNo" value="${img.imgNo ?? ""}" disabled style="width:100%; padding:8px; border:1px solid #e9ecef; border-radius:8px; background:#f8f9fa; font-size:13px;"/>
                </div>
                <div>
                    <label style="display:block; font-size: 11px; color: #888; margin-bottom: 2px;">매핑번호</label>
                    <input type="text" name="mapNo" value="${img.mapNo ?? ""}" disabled style="width:100%; padding:8px; border:1px solid #e9ecef; border-radius:8px; background:#f8f9fa; font-size:13px;"/>
                </div>
            </div>

            <div style="width: 550px; display: flex; flex-direction: column;"> <label style="display:block; font-size: 12px; color: #888; margin-bottom: 0px; font-weight: bold; text-align:center;">미리보기</label>
                <div style="height: 300px; background: #f8f9fa; border-radius: 12px; overflow: hidden; display: flex; align-items: center; justify-content: center; border: 1px solid #eee;"><img src="${imgSrc}"
                         alt="${img.originName}"
                         style="width: 100%; height: 100%; object-fit: contain; transition: transform 0.3s;"
                         onmouseover="this.style.transform='scale(1.1)'"
                         onmouseout="this.style.transform='scale(1)'"
                         onerror="this.src='https://via.placeholder.com/300?text=No+Image'"/>
                </div>
                <div style="font-size: 11px; color: #bbb; margin-top: 1px; text-align: center;">
                    FILE SIZE: ${img.fileSize ? (img.fileSize.toLocaleString() + ' bytes') : '? bytes'}
                </div>
            </div>
        </div>`;
}

// 이미지순서(view_sequence) 리스너
document.addEventListener("click", async (e) => {
  const btn = e.target.closest(".btn-viewseq-apply");
  if(!btn) return;

  const regId = btn.dataset.regid;
  const mapNo = btn.dataset.mapno;

  const card = btn.closest(".img-form-item");
  const seqInp = card?.querySelector(".inp-view-seq") || card?.querySelector('input[name="viewSequence"]');
  const v = (seqInp?.value ?? "").toString().trim();

  const seqNum = Number(v);
  if(!regId || !mapNo){
    alert("regId/mapNo를 읽지 못했습니다.");
    return;
  }
  if(!Number.isInteger(seqNum) || seqNum < 1){
    alert("이미지순서는 1 이상의 정수로 입력하세요.");
    seqInp?.focus();
    return;
  }

  btn.disabled = true;

  try{
    const resp = await fetch(contextPath + "/adRegImgUpdateViewSeq.do", {
      method: "POST",
      headers: {"Content-Type":"application/json;charset=UTF-8"},
      body: JSON.stringify({
        regId,
        mapNo: Number(mapNo),
        viewSequence: seqNum
      })
    });

    const json = await resp.json();
    if(!json.ok){
      alert(json.message || "순서 변경 실패");
      return;
    }

    // 성공 UX (원하면 alert 대신 토스트로)
    alert("순서 변경 완료");

     //순서 재정렬 해서 화면 다시 그리기
     const box = document.querySelector("#tab-img-" + regId + " .async-container");  // #tab~의 하위선택자 async-container
     if(box){ box.dataset.loaded="0"; await loadRegImg(regId); }

  }catch(err){
    console.error(err);
    alert("요청 중 오류 발생");
  }finally{
    btn.disabled = false;
  }
});

// 이미지등록 클릭 리스너
document.addEventListener("click", (e) => {
  const btn = e.target.closest(".btn-regimg-add");
  if(!btn) return;

  const regId = btn.dataset.regid;
  const box = document.querySelector("#tab-img-" + regId + " .async-container");  // #tab~의 하위선택자 async-container
  if(!box) return;

  const form = box.querySelector("form.img-update-form");
  if(!form) return;

  // 새 폼은 기존 목록 위에 추가(원하면 append로 아래에 붙여도 됨)
  const newHtml = renderNewImgForm(regId);
  form.insertAdjacentHTML("beforeend", newHtml);

  // 새로 추가한 카드로 스크롤(UX)
  // ✅ (수정) firstNew -> lastNew
  const newCards = form.querySelectorAll('.img-form-item[data-mode="new"]');
  const lastNew = newCards[newCards.length - 1];
  if(lastNew) lastNew.scrollIntoView({behavior:"smooth", block:"center"});
});


// 이미지 등록을 위한 새카드(빈카드) 렌더링
function renderNewImgForm(regId){

  // ✅ (추가) NEW 카드마다 고유 draftId 부여 (등록된 카드만 drafts에서 제거하기 위한 키)
  const draftId = "d" + Date.now() + "_" + Math.random().toString(16).slice(2);

  return `
  <div class="img-form-item" data-mode="new" data-draftid="${draftId}"
       style="display:flex; flex-direction:column; gap:14px;
              border:1px solid #dbeafe;
              border-radius:16px;
              padding:16px;
              background:#f8fbff;
              margin-top:10px;
              margin-bottom:10px;">  <!-- ✅ (수정) 깨진 속성 정리: margin-bottom을 style 안으로 -->

    <!-- 헤더(NEW + 취소) -->
    <div style="display:flex; align-items:center; justify-content:space-between; gap:12px;">

	  <div style="display:flex; align-items:center; gap:10px;">
        <span style="font-size:12px; font-weight:800; color:#1d4ed8;
              background:#dbeafe; padding:4px 10px; border-radius:999px;">
          NEW
        </span>
        <span style="font-size:12px; color:#64748b;">
          새 이미지 등록
        </span>
      </div>

	  <div>
	  	<button type="button" class="btnX blue sm btn-new-row-apply"
	    	style="height:34px; padding:0 16px; border-radius:10px; background:#1d4ed8;
			color:gold; border:none; font-weight:bold; cursor:pointer;">
	  	등록적용
	  	</button>

	  	<button type="button" class="btnX gray sm btn-new-row-remove"
        	style="height:34px; padding:0 12px; border-radius:10px;">
      	취소
      	</button>
	  </div>

    </div>

    <!-- 본문(좌 폼 / 우 미리보기) -->
    <div style="display:flex; gap:18px; align-items:stretch; flex-wrap:wrap;">

      <!-- 좌: 입력 -->
      <div style="flex:1.5; min-width:320px; display:grid; grid-template-columns:repeat(2,1fr); gap:12px;">
        <div style="grid-column:1/-1;">
          <label style="display:block; font-size:12px; color:#64748b; margin-bottom:6px; font-weight:700;">
            이미지경로(필수)
          </label>

          <input type="text" name="newImgPath" class="newImgPath"
                 placeholder="/upload_img/reg_img/파일명.jpg"
                 autocomplete="off"
                 style="width:100%; height:40px; padding:0 12px;
                        border:1px solid #e5e7eb; border-radius:12px; background:#fff;">

          <div class="imgpath-picker"
               style="display:none; margin-top:10px; border:1px solid #e2e8f0; border-radius:12px; background:#fff;
                      max-height:260px; overflow:auto;">
            <div class="imgpath-picker-head" style="padding:10px; border-bottom:1px solid #f1f5f9;">
              <input type="text" class="imgpath-filter" placeholder="검색..."
                     style="width:100%; height:36px; padding:0 10px; border:1px solid #e5e7eb; border-radius:10px;">
            </div>
            <div class="imgpath-picker-list"
                 style="padding:10px; display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:10px;"></div>
          </div>
        </div>

        <div>
          <label style="display:block; font-size:12px; color:#64748b; margin-bottom:6px; font-weight:700;">
            이미지순서(선택)
          </label>
          <input type="number" name="newViewSequence" placeholder="예: 1"
                 style="width:100%; height:40px; padding:0 12px;
                        border:1px solid #e5e7eb; border-radius:12px; background:#fff;">
        </div>

        <div>
          <label style="display:block; font-size:12px; color:#64748b; margin-bottom:6px; font-weight:700;">
            원본명
          </label>
          <input type="text" name="newOriginName" placeholder="예: sample1.jpg"
                 style="width:100%; height:40px; padding:0 12px;
                        border:1px solid #e5e7eb; border-radius:12px; background:#fff;">
        </div>
      </div>

      <!-- 우: 미리보기 -->
      <div style="flex:1; min-width:260px; display:flex; flex-direction:column; gap:10px;">
        <div style="display:flex; justify-content:space-between; align-items:center;">
          <label style="font-size:12px; color:#64748b; font-weight:800;">
            미리보기
          </label>
          <span style="font-size:11px; color:#94a3b8;">(입력 후 반영)</span>
        </div>

        <div class="new-preview"
             style="height:180px; border:1px dashed #cbd5e1; border-radius:14px;
                    background:#fff; display:flex; align-items:center; justify-content:center; overflow:hidden;">
          <span style="font-size:12px; color:#94a3b8;">경로 입력하면 미리보기</span>
        </div>
      </div>

    </div>
  </div>`;
}

// 이미지 <등록삭제> 버튼 동작 함수 (체크된 mapNo 매핑 삭제)
document.addEventListener("click", async (e) => {
  const deleteBtn = e.target.closest(".btn-img-delete");
  if(!deleteBtn) return;

  const regId = deleteBtn.dataset.regid;
  const box = document.querySelector("#tab-img-" + regId + " .async-container");
  if(!box) return;

  const form = box.querySelector("form.img-update-form");
  if(!form) return;

  // ✅ NEW 카드(data-mode="new")는 삭제 대상에서 제외
  const checked = Array.from(form.querySelectorAll('input[name="selectedImg"]:checked'))
    .filter(chk => !chk.closest('.img-form-item')?.dataset?.mode);

  if(checked.length === 0){
    alert("삭제할 이미지를 체크하세요.");
    return;
  }

  // ✅ 이제 체크박스 value가 mapNo
  const mapNoList = checked
    .map(chk => String(chk.value).trim())
    .filter(v => v && v !== "null" && v !== "undefined");

  if(mapNoList.length === 0){
    alert("선택된 항목의 매핑번호(mapNo)를 읽지 못했습니다.");
    return;
  }

  if(!confirm(`선택한 ${mapNoList.length}개 이미지를 매핑에서 삭제할까요?\n(IMG_STORAGE/파일은 삭제되지 않음)`)){
    return;
  }

  deleteBtn.disabled = true;

  try{
    const resp = await fetch(contextPath + "/adRegImgDeleteMapping.do", {
      method: "POST",
      headers: {"Content-Type":"application/json;charset=UTF-8"},
      body: JSON.stringify({
        regId,
        mapNoList
      })
    });

    const json = await resp.json();
    if(!json.ok){
      alert(json.message || "삭제 실패");
      return;
    }

    alert(json.message || "삭제 성공");

    // ✅ (유지) 화면에서 즉시 제거
    checked.forEach(chk => {
      const card = chk.closest(".img-form-item");
      if(card) card.remove();
    });

    // ✅ 서버 기준으로 재렌더링(NEW 폼은 save/restore로 유지됨)
    box.dataset.loaded = "0";
    await loadRegImg(regId);

  }catch(err){
    console.error(err);
    alert("요청 중 오류가 발생했습니다.");
  }finally{
    deleteBtn.disabled = false;
  }
});


// 이미지등록 새카드의 <등록적용> 버튼 동작
document.addEventListener("click", async (e) => {
  const applyBtn = e.target.closest(".btn-new-row-apply");
  if(!applyBtn) return;

  const item = applyBtn.closest('.img-form-item[data-mode="new"]');
  const form = item.closest("form.img-update-form");
  const regId = form?.querySelector('input[name="regId"]')?.value;

  const imgPath = item.querySelector('input[name="newImgPath"]')?.value?.trim();
  const viewSequence = item.querySelector('input[name="newViewSequence"]')?.value?.trim();
  const originName = item.querySelector('input[name="newOriginName"]')?.value?.trim();

  // ✅ (추가) 이 NEW 카드의 고유 id (등록된 카드만 제거하기 위한 키)
  const appliedDraftId = item?.dataset?.draftid || "";

  if(!regId) {
    alert("등록번호를 읽어올 수 없습니다.");
    return;
  }

  if(!imgPath) {
    alert("이미지 경로를 입력해주세요.");
    return;
  }

  applyBtn.disabled = true; // 한번에 여러번 클릭시 중복 독작 방지

  // ✅ (유지) 재렌더 대비 NEW 입력값 저장
  saveNewDrafts(regId, form);

  // 혹시 모를 상황(인터넷 끊김 등)을 위해 try-catch로 예외상황 대비
  try{
    const resp = await fetch(contextPath + "/adRegImgApply.do", { // 서블릿으로 데이터를 JSON직렬화해서 보냄, resp로 응답을 받음
      method: "POST",
      headers: {"Content-Type":"application/json;charset=UTF-8"},
      body: JSON.stringify({
        regId,
        imgPath,
        viewSequence : viewSequence || null,
        originName: originName || null
      })
    });

    const json = await resp.json(); // resp를 json()파싱해서 json에 저장
    if(!json.ok){ // 서블릿으로 부터 응답받은 resp플래그가 ok이면 성공 아니면 실패
      alert(json.message || "등록실패"); // ok가 아닌경우 메시지 + 함수 종료
      return;
    }

    // 성공 메시지(원래 있던 UX 복구)
    alert(json.message || "등록성공");
	
	item.remove();
	
    // 등록된 카드만 드래프트에서 제거 → 재렌더 후에도 복원되지 않음
    const drafts = __newImgDrafts.get(String(regId)) || [];
    const nextDrafts = drafts.filter(d => String(d.draftId || "") !== String(appliedDraftId || ""));
    __newImgDrafts.set(String(regId), nextDrafts);

    // ✅ 등록 후 서버 기준 전체 재렌더링(NEW 폼은 save/restore로 유지됨)
    const box = document.querySelector("#tab-img-" + regId + " .async-container");
    if(box){
      box.dataset.loaded = "0";
      await loadRegImg(regId);
    }

  }catch(err){
    console.error(err);
    alert("요청 중 오류가 발생했습니다.");
  }finally{
    applyBtn.disabled = false;
  }

});


// 이미지 등록을 위한 새카드 <취소> 버튼 동작(해당 새카드 삭제)
document.addEventListener("click", (e) => {
  const rm = e.target.closest(".btn-new-row-remove");
  if(!rm) return;

  const item = rm.closest('.img-form-item[data-mode="new"]');
  if(!item) return;

  // ✅ (추가) 취소한 카드도 drafts에서 제거(재렌더 시 다시 살아나는 케이스 방지)
  const form = item.closest("form.img-update-form");
  const regId = form?.querySelector('input[name="regId"]')?.value;
  const draftId = item?.dataset?.draftid || "";

  item.remove();

  if(regId && draftId){
    const drafts = __newImgDrafts.get(String(regId)) || [];
    const nextDrafts = drafts.filter(d => String(d.draftId || "") !== String(draftId || ""));
    __newImgDrafts.set(String(regId), nextDrafts);
  }
});

// 경로 입력해서 미리보기(뷰검증용)
document.addEventListener("input", (e) => {
  const inp = e.target.closest('input[name="newImgPath"]');
  if(!inp) return;

  const item = inp.closest('.img-form-item[data-mode="new"]');
  const preview = item?.querySelector(".new-preview");
  if(!preview) return;

  const previewImgPath = (inp.value || "").trim();
  if(!previewImgPath){
    preview.innerHTML = `<span style="font-size:12px; color:#94a3b8;">이미지가 경로에 없습니다.</span>`;
    return;
  }

  preview.innerHTML = `
    <img src="${contextPath}${previewImgPath}" style="max-width:100%; max-height:100%; object-fit:contain;"
         onerror="this.onerror=null; this.src='${contextPath}/assets/images/common/default_images/penguin.jpg'">`;
});


// 폴더 목록 캐시(같은 페이지에서 반복 호출 방지)
const __regImgPoolCache = new Map(); // key: folder, value: array

// input 클릭/포커스 시 목록 열기
document.addEventListener("focusin", async (e) => {
  const inp = e.target.closest('input[name="newImgPath"]');
  if(!inp) return;

  const item = inp.closest('.img-form-item[data-mode="new"]');
  if(!item) return;

  const picker = item.querySelector(".imgpath-picker");
  const listEl = item.querySelector(".imgpath-picker-list");
  const filterEl = item.querySelector(".imgpath-filter");
  if(!picker || !listEl || !filterEl) return;

  // 이미 열려있으면 그냥 유지
  picker.style.display = "block";

  // 목록이 이미 그려져 있으면 fetch 생략
  if (picker.dataset.loaded === "1") {
    filterEl.focus();
    return;
  }

  listEl.innerHTML = `<div style="grid-column:1/-1; color:#64748b;">불러오는 중...</div>`;

  // 서버 API: reg_img 폴더 목록을 JSON으로 내려주면 됨
  const folder = "reg_img";
  try {
    const data = await fetchRegImgPool(folder);

    // data 예상 형태: [{fileName:"a.jpg", imgPath:"/upload_img/reg_img/a.jpg", registered:true/false}, ...]
    picker.dataset.loaded = "1";
    picker.dataset.folder = folder;
    picker.dataset.raw = JSON.stringify(data); // 필터링용

    renderPickerList(listEl, data);
    filterEl.value = "";
    filterEl.focus();
  } catch (err) {
    console.error(err);
    listEl.innerHTML = `<div style="grid-column:1/-1; color:#ef4444;">목록을 불러오지 못했습니다.</div>`;
  }
});

// 검색 필터링
document.addEventListener("input", (e) => {
  const filterEl = e.target.closest(".imgpath-filter");
  if(!filterEl) return;

  const item = filterEl.closest('.img-form-item[data-mode="new"]');
  const picker = item?.querySelector(".imgpath-picker");
  const listEl = item?.querySelector(".imgpath-picker-list");
  if(!picker || !listEl) return;

  const raw = picker.dataset.raw ? JSON.parse(picker.dataset.raw) : [];
  const q = (filterEl.value || "").trim().toLowerCase();

  const filtered = !q
    ? raw
    : raw.filter(it => (it.fileName || it.imgPath || "").toLowerCase().includes(q));

  renderPickerList(listEl, filtered);
});

// 항목 선택 → 이미지경로 input 채우기
document.addEventListener("click", (e) => {
  const opt = e.target.closest("[data-imgpath-option]");
  if(!opt) return;

  const imgPath = opt.dataset.imgpath || "";
  const item = opt.closest('.img-form-item[data-mode="new"]');
  const pathInp = item?.querySelector('input[name="newImgPath"]');
  const originInp = item?.querySelector('input[name="newOriginName"]');
  const picker = item?.querySelector(".imgpath-picker");
   if(!pathInp || !picker) return;

    // 1) 경로 입력
    pathInp.value = imgPath;

    // 2) 원본명 자동 입력 (경로에서 파일명만 추출)
    if(originInp){
      originInp.value = extractFileName(imgPath); // ex) sample.jpg
    }

    // 3) 드롭다운 닫기
    picker.style.display = "none";

    // 4) 미리보기 갱신 트리거
    pathInp.dispatchEvent(new Event("input", { bubbles: true }));
});

  // "/upload_img/reg_img/a/b/c.jpg?x=1" -> "c.jpg"
  // 이미지 원본명 input채우기 (이미지 경로에서 추출)
function extractFileName(path){
   if(!path) return "";

    // 쿼리스트링 제거
   const clean = String(path).split("?")[0];

   // 마지막 슬래시 뒤
   const parts = clean.split("/");

    return parts[parts.length - 1] || "";
}

// 이미지 경로 목록창 바깥 클릭하면 해당 창 닫기
document.addEventListener("click", (e) => {
  // picker 내부 클릭은 무시
  if (e.target.closest(".imgpath-picker")) return;
  if (e.target.closest('input[name="newImgPath"]')) return;

  document.querySelectorAll(".imgpath-picker").forEach(p => {
    p.style.display = "none";
  });
});

// 이미지 경로 목록창 ESC로 닫기
document.addEventListener("keydown", (e) => {
  if(e.key !== "Escape") return;
  document.querySelectorAll(".imgpath-picker").forEach(p => {
    p.style.display = "none";
  });
});

// 이미지 경로 목록 렌더링
function renderPickerList(listEl, arr){
  if(!arr || arr.length === 0){
    listEl.innerHTML = `<div style="grid-column:1/-1; color:#64748b;">목록이 없습니다.</div>`;
    return;
  }

  listEl.innerHTML = arr.map(it => {
    const badge = it.registered
      ? `<span style="font-size:11px; font-weight:800; color:#0f172a; background:#e8efff; padding:3px 6px; border-radius:999px;">등록됨</span>`
      : `<span style="font-size:11px; font-weight:800; color:#14532d; background:#dcfce7; padding:3px 6px; border-radius:999px;">미등록</span>`;

    return `
      <div data-imgpath-option="1"
           data-imgpath="${it.imgPath}"
           style="border:1px solid #eef2f7; border-radius:12px; padding:8px; cursor:pointer;">
        <div style="display:flex; justify-content:space-between; align-items:center; gap:6px;">
          <div style="font-size:12px; color:#334155; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">
            ${it.fileName || it.imgPath}
          </div>
          ${badge}
        </div>
        <div style="margin-top:6px; height:90px; background:#f8fafc; border:1px solid #f1f5f9; border-radius:10px; display:flex; align-items:center; justify-content:center; overflow:hidden;">
          <img src="${contextPath}${it.imgPath}" style="max-width:100%; max-height:100%; object-fit:contain;"
               onerror="this.onerror=null; this.src='${contextPath}/assets/images/common/default_images/penguin.jpg'">
        </div>
      </div>
    `;
  }).join("");
}

// 서버에서 폴더 목록 가져오기
async function fetchRegImgPool(folder){
  if(__regImgPoolCache.has(folder)) return __regImgPoolCache.get(folder);

  const url = contextPath + "/adRegImgPoolList.do?folder=" + encodeURIComponent(folder);
  console.log("POOL FETCH URL =", url);

  const resp = await fetch(url);

  if(!resp.ok){
    const txt = await resp.text();
    console.error("POOL HTTP ERROR", resp.status, txt.slice(0, 200));
    throw new Error("POOL HTTP " + resp.status);
  }

  const json = await resp.json();
  if(!json.ok) throw new Error(json.message || "pool list fail");

  __regImgPoolCache.set(folder, json.data || []);
  return json.data || [];
}
