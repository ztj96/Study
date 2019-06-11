﻿#ifndef GN_SYSTEM_WRAPPERS_SOURCE_FILE_IMPL_H_
#define GN_SYSTEM_WRAPPERS_SOURCE_FILE_IMPL_H_

#include <stdio.h>

#include "system_wrappers/interface/file_wrapper.h"
#include "system_wrappers/interface/scoped_ptr.h"

namespace gn
{

	class RWLockWrapper;

	class FileWrapperImpl : public FileWrapper
	{
	public:
		FileWrapperImpl();
		virtual ~FileWrapperImpl();

		virtual int FileName(char* file_name_utf8,
			size_t size) const OVERRIDE;

		virtual bool Open() const OVERRIDE;

		virtual int OpenFile(const char* file_name_utf8,
			bool read_only,
			bool loop = false,
			bool text = false) OVERRIDE;

		virtual int CloseFile() OVERRIDE;
		virtual int SetMaxFileSize(size_t bytes) OVERRIDE;
		virtual int Flush() OVERRIDE;

		virtual int Read(void* buf, int length) OVERRIDE;
		virtual bool Write(const void* buf, int length) OVERRIDE;
		virtual int WriteText(const char* format, ...) OVERRIDE;
		virtual int Rewind() OVERRIDE;

	private:
		int CloseFileImpl();
		int FlushImpl();

		scoped_ptr<RWLockWrapper> rw_lock_;

		FILE* id_;
		bool open_;
		bool looping_;
		bool read_only_;
		size_t max_size_in_bytes_;  // -1 indicates file size limitation is off
		size_t size_in_bytes_;
		char file_name_utf8_[kMaxFileNameSize];
	};

}  // namespace gn

#endif  // GN_SYSTEM_WRAPPERS_SOURCE_FILE_IMPL_H_
