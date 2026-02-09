# Branch Protection Setup

## วิธีตั้งค่าห้าม merge เข้า main โดยตรง

### ขั้นตอนการตั้งค่าใน GitHub:

1. ไปที่ Repository → **Settings**
2. ไปที่ **Branches** (ในเมนูด้านซ้าย)
3. กดปุ่ม **Add branch protection rule**
4. ตั้งค่าดังนี้:

### Branch name pattern

```
main
```

### Protection Rules ที่แนะนำ:

#### ✅ Require a pull request before merging

- เปิดใช้งานเพื่อบังคับให้ต้องสร้าง Pull Request ก่อน merge
- **Require approvals**: จำนวนคนที่ต้อง approve (แนะนำ 1 คน)
- ✅ **Dismiss stale pull request approvals when new commits are pushed**
- ✅ **Require review from Code Owners** (ถ้ามีไฟล์ CODEOWNERS)

#### ✅ Require status checks to pass before merging

- ✅ **Require branches to be up to date before merging**
- เลือก status checks ที่ต้อง pass:
    - Analyze code
    - Run tests (ถ้ามี)

#### ✅ Require conversation resolution before merging

- บังคับให้ต้อง resolve comments ทั้งหมดก่อน merge

#### ✅ Do not allow bypassing the above settings

- ไม่ให้ admin bypass rules (แนะนำสำหรับความปลอดภัย)

#### ❌ Allow force pushes (ปิดไว้)

- ห้าม force push เข้า main

#### ❌ Allow deletions (ปิดไว้)

- ห้ามลบ branch main

---

## Development Workflow

### 1. สร้าง feature branch

```bash
git checkout -b feature/your-feature-name
# หรือ
git checkout -b fix/bug-description
```

### 2. ทำงานและ commit

```bash
git add .
git commit -m "Your commit message"
git push origin feature/your-feature-name
```

### 3. สร้าง Pull Request

- ไปที่ GitHub repository
- กดปุ่ม "Compare & pull request"
- เขียน description อธิบายการเปลี่ยนแปลง
- Request review (ถ้ามี)

### 4. Review และ Merge

- รอให้ CI/CD tests ผ่าน
- รอให้มีคน approve (ถ้าตั้งค่าไว้)
- Merge เข้า main ผ่าน GitHub UI

### 5. Deploy (ด้วย Tag)

```bash
# Checkout main และ pull ล่าสุด
git checkout main
git pull origin main

# สร้าง tag version
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

---

## Branch Naming Convention

- `feature/*` - สำหรับ feature ใหม่
- `fix/*` - สำหรับแก้ bug
- `hotfix/*` - สำหรับแก้ปัญหาเร่งด่วน
- `refactor/*` - สำหรับ refactor code
- `docs/*` - สำหรับแก้ไข documentation

---

## หมายเหตุ

การตั้งค่า Branch Protection จะช่วย:

- ป้องกันการ push โดยตรงเข้า main
- ให้มีการ code review ก่อน merge
- รับรองว่า tests ผ่านก่อน merge
- เก็บประวัติการเปลี่ยนแปลงที่ชัดเจน
